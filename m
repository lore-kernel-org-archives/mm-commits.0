Return-Path: <SRS0=JcVV=BI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0334C433E5
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jul 2020 01:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86CDC20656
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jul 2020 01:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595987064;
	bh=WGU+RwgUDV1Np4h4picpfMVw+HoxLK7aOFBh58G7DpU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:List-ID:
	 From;
	b=BtGdDSvI7ixcnguVrmmralVLe4URQIBt2NilVm1BbTZbKN6SvlRyJ3nYx6XwNi80F
	 wcZ0eIY88T/qF7F6/NZcYL3IKAzGMhl1kncd/uMC0gzx5nr/Uv3QvQFeN3faEqkZic
	 G2DNbf3iFTPNQmLWTzglUN01fqKuWDhK0KlGf9bY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgG2BoU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jul 2020 21:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730207AbgG2BoU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jul 2020 21:44:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A23A62076E;
        Wed, 29 Jul 2020 01:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595987060;
        bh=WGU+RwgUDV1Np4h4picpfMVw+HoxLK7aOFBh58G7DpU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nneT/uOCq8J+xa61cFEtSgzI3t0O9XNtf3cRni7FxwDYiNfvmSyCN8isbVM+OcMd3
         r9Z1z7FOrh0ABsM6rZpyBwP1JbscCy92SvO7m4Sopc825sj3dkqnYHEsWIHqTqeePh
         jnVV67kmT15wDMBA1iWFRRQjzvqqrZ4e+iVDVjq0=
Date:   Tue, 28 Jul 2020 18:44:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     broonie@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: mmotm 2020-07-27-18-18 uploaded (mm/page_alloc.c)
Message-Id: <20200728184419.4b137162844987c9199542bb@linux-foundation.org>
In-Reply-To: <048cef07-ad4b-8788-94a4-e144de731ab6@infradead.org>
References: <20200728011914.S-8vAYUK0%akpm@linux-foundation.org>
        <ae87385b-f830-dbdf-ebc7-1afb82a7fed0@infradead.org>
        <20200728145553.2a69fa2080de01922b3a74e0@linux-foundation.org>
        <048cef07-ad4b-8788-94a4-e144de731ab6@infradead.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 28 Jul 2020 15:39:21 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> On 7/28/20 2:55 PM, Andrew Morton wrote:
> > On Tue, 28 Jul 2020 05:33:58 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
> > 
> >> On 7/27/20 6:19 PM, Andrew Morton wrote:
> >>> The mm-of-the-moment snapshot 2020-07-27-18-18 has been uploaded to
> >>>
> >>>    http://www.ozlabs.org/~akpm/mmotm/
> 
> 
> >> on x86_64:
> >>
> >> ../mm/page_alloc.c:8355:48: warning: ‘struct compact_control’ declared inside parameter list will not be visible outside of this definition or declaration
> >>  static int __alloc_contig_migrate_range(struct compact_control *cc,
> >>                                                 ^~~~~~~~~~~~~~~
> > 
> > As is usually the case with your reports, I can't figure out how to
> > reproduce it.  I copy then .config, run `make oldconfig' (need to hit
> > enter a zillion times because the .config is whacky) then the build
> > succeeds.  What's the secret?
> 
> I was not aware that there was a problem. cp .config and make oldconfig
> should be sufficient -- and I don't understand why you would need to hit
> enter many times.
> 
> I repeated this on my system without having to answer any oldconfig prompts
> and still got build errors.
> 
> There is no secret that I know of, but it would be good to get to the
> bottom of this problem.

Well the first thing I hit was

Support for big SMP systems with more than 8 CPUs (X86_BIGSMP) [N/y/?] (NEW) 

and your .config doesn't mention that.

make mrproper
cp ~/config-randy .config
make oldconfig


