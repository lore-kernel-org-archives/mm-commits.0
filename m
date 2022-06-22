Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CC3C43334
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 14:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357989AbiFVOVY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Jun 2022 10:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358175AbiFVOVY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2022 10:21:24 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A20062D9
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 07:21:19 -0700 (PDT)
Received: from zn.tnic (p200300ea974657a8329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9746:57a8:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F09431EC0432;
        Wed, 22 Jun 2022 16:21:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1655907673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=his6AREgNwUOcgnQ+a3chr9iKtHV7zPpU83pOda0rZQ=;
        b=d1/sLmZ4NX6wGx0Z24i7Bcf25r5hyIfj758idWb0wuuQg0nIG/+4YsW++zKG0OdrO18xc3
        cMkjvsgqwf3CutrCQ9oXHllj8GIGRsRkQrk5o2jffLoFlKdjYAZ7q/mH9VGtbXvDUjyErm
        O1lnqYbK5LuQCQ/Smuj0Rxtxm844qFE=
Date:   Wed, 22 Jun 2022 16:21:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] x86/clear_user: Make it faster
Message-ID: <YrMlVBoDxB21l/kD@zn.tnic>
References: <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic>
 <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic>
 <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic>
 <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic>
 <Ynq1nVpu1xCpjnXm@zn.tnic>
 <YozQZMyQ0NDdD8cH@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YozQZMyQ0NDdD8cH@zn.tnic>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, May 24, 2022 at 02:32:36PM +0200, Borislav Petkov wrote:
> I still need to run it on production Icelake and that is kinda being
> delayed due to server room cooling issues (don't ask ;-\).

So I finally got a production level ICL-X:

[    0.220822] smpboot: CPU0: Intel(R) Xeon(R) Gold 6336Y CPU @ 2.40GHz (family: 0x6, model: 0x6a, stepping: 0x6)

and frankly, this looks really weird:

clear_user_original:
Amean: 19679.4 (Sum: 13652560764, samples: 693750)
Amean: 19743.7 (Sum: 13693470604, samples: 693562)

(I ran it twice just to be sure.)

ERMS:
Amean: 20374.3 (Sum: 13910601024, samples: 682752)
Amean: 20453.7 (Sum: 14186223606, samples: 693576)

FSRM:
Amean: 20458.2 (Sum: 13918381386, sample s: 680331)

so either that particular box is weird or Icelake really is slower wrt
FSRM or I've fat-fingered it somewhere.

But my measuring is as trivial as:

static __always_inline unsigned long clear_user(void __user *to, unsigned long n)
{
	if (access_ok(to, n)) {
		unsigned long start, end, ret;

		start = rdtsc_ordered();
		ret = __clear_user(to, n);
		end = rdtsc_ordered();

		trace_printk("to: 0x%lx, size: %ld, cycles: %lu\n", (unsigned long)to, n, end - start);

		return ret;
	}

	return n;
}

so if anything I don't see what the problem could be...

Hmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
