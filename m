Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B480C433EF
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 07:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbiGCHcf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 03:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiGCHcc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 03:32:32 -0400
X-Greylist: delayed 547 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 03 Jul 2022 00:32:31 PDT
Received: from polaris.svanheule.net (polaris.svanheule.net [IPv6:2a00:c98:2060:a004:1::200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBA5AE5D
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 00:32:31 -0700 (PDT)
Received: from [IPv6:2a02:a03f:eaf9:8401:aa9f:5d01:1b2a:e3cd] (unknown [IPv6:2a02:a03f:eaf9:8401:aa9f:5d01:1b2a:e3cd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sander@svanheule.net)
        by polaris.svanheule.net (Postfix) with ESMTPSA id 2E74D2F2F69;
        Sun,  3 Jul 2022 09:23:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svanheule.net;
        s=mail1707; t=1656833001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sKgxlYCxZv8lvQjE1mgOhft6/OnrbVmwcAHRoRjX9UY=;
        b=jn84Dxka9498cI88H8cPYBA5E00TCrT8GdJRfCFy70jQRWVKvd76+LyW1Y2FbJBSCcabJC
        qqMBpf7LRsbIz4UJKA2xYeg56+DYtWVVknRjeO+7SYwKjUm3Q02pnpMyf129dZZ6RZ7Xxs
        uGWYXJmt+hXUIlreonjqn/6ND66G+AhxjfJGLx3bAS1F+9Z1q5lQwFoPwRkB52eK2+I2nS
        roy4PI5IIX1zLlaAXT7+D83NKd2wFSV3UgwMhzHwBnTW4Y/pOku12C/1HJUcqKA2yZpTjE
        9VMR9OS/FJP6iSN7WOhLThI0q0Yi1bmMdR8776wzOmGBJbMNM5SfWph4ygzfew==
Message-ID: <0b414dbcf5bb3fb34ff7adfdb6a2139c202b137b.camel@svanheule.net>
Subject: Re: + lib-test-introduce-cpumask-kunit-test-suite.patch added to
 mm-nonmm-unstable branch
From:   Sander Vanheule <sander@svanheule.net>
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, yury.norov@gmail.com,
        vschneid@redhat.com, tglx@linutronix.de, peterz@infradead.org,
        mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        elver@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andriy.shevchenko@linux.intel.com
Date:   Sun, 03 Jul 2022 09:23:19 +0200
In-Reply-To: <20220702203945.6D981C34114@smtp.kernel.org>
References: <20220702203945.6D981C34114@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, 2022-07-02 at 13:39 -0700, Andrew Morton wrote:
> >=20
> > The patch titled
> > =C2=A0=C2=A0=C2=A0=C2=A0 Subject: lib/test: ontroduce cpumask KUnit tes=
t suite
> > has been added to the -mm mm-nonmm-unstable branch.=C2=A0 Its filename =
is
> > =C2=A0=C2=A0=C2=A0=C2=A0 lib-test-introduce-cpumask-kunit-test-suite.pa=
tch
> >=20
> > This patch will shortly appear at
> > =C2=A0=C2=A0=C2=A0=C2=A0 >
> > https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pa=
tches/lib-test-introduce-cpumask-kunit-test-suite.patch
> >=20
> > This patch will later appear in the mm-nonmm-unstable branch at
> > =C2=A0=C2=A0=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/akpm/m=
m
> >=20
> > Before you just go and hit "reply", please:
> > =C2=A0=C2=A0 a) Consider who else should be cc'ed
> > =C2=A0=C2=A0 b) Prefer to cc a suitable mailing list as well
> > =C2=A0=C2=A0 c) Ideally: find the original patch on the mailing list an=
d do a
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reply-to-all to that, adding suitable ad=
ditional cc's
> >=20
> > *** Remember to use Documentation/process/submit-checklist.rst when tes=
ting your code > ***
> >=20
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> >=20
> > ------------------------------------------------------
> > From: Sander Vanheule <sander@svanheule.net>
> > Subject: lib/test: ontroduce cpumask KUnit test suite

Something went wrong here, because the subject changed from "Introduce" to =
"ontroduce". I also
noticed that the capitalisation after the prefix was removed for all but th=
e second patch. I'll do
lowercase for the next series revision, so no (manual) fixups are required.

Best,
Sander

> > Date: Sat, 2 Jul 2022 18:08:26 +0200
> >=20
> > Add a basic suite of tests for cpumask, providing some tests for empty =
and
> > completely filled cpumasks.
> >=20
> > Link: >
> > https://lkml.kernel.org/r/c96980ec35c3bd23f17c3374bf42c22971545e85.1656=
777646.git.sander@svanheule.net
> > Signed-off-by: Sander Vanheule <sander@svanheule.net>
> > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Marco Elver <elver@google.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Valentin Schneider <vschneid@redhat.com>
> > Cc: Yury Norov <yury.norov@gmail.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

