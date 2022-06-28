Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC1BC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 15:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346595AbiF1PqW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 11:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347940AbiF1PqV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 11:46:21 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65103377F1
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 08:46:19 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v14so18294110wra.5
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 08:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wowsignal-io.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jF0V/DuhCFsgK9aIagWDve53F5wfTijhQS8wPYxi5Gs=;
        b=UNUQ0+wHG4xsXvyMc3HJQzWthUTyrLMU5DICX2v/0se++7azjm7BCDaWjwnTOvCmt7
         Cam5Yxk927i/5gKaDshRt7x7gV+yrNuZFQuS3ZzYoHhwPHZBh92kV1qdfGlZpq0XXc8f
         0VgYk5lPMJwcjhHH0Ge6XphiKJ46e3Lv5QOHsmy1Pn9MWEflhuNlPFkyTlRceFpjyrI3
         iBmpDFkS5/yOnboSxm3rIfsllOHeCkp/bY+QI8r5fK9+rbtWnB3jUHJvA8WnLxPjLOeZ
         QyrU1TI4x8RGLzPzyK+I+Z/ys3eeXAyxzjSWefDUhaa+4/Md/bd9T7oDykfQMB8LxSm+
         A2Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jF0V/DuhCFsgK9aIagWDve53F5wfTijhQS8wPYxi5Gs=;
        b=a2PTQttALhh5cKV9rq0PfI2Mjb6Qw7f/LxG+RYnroWXihx7m7jLegB7YrgrP3xyYVr
         j5WSsV2Hk2sH+ylVqbFs9B728fOos5Tv+AXbSXhvjlMNIUUORW56Qm0+f3mBNWiGFHEl
         jQoHlC55IpTQp/wdAEz4ZuVYWq0AurQzjdUhiZf30JevjdVwB7VISwhWkvFHouRNtAko
         jSZeAqYFT2ILKbXIWOAeeaiBacgy09RoEcWuQQRjJlwH7NkX2rUHPB55e1HsOFRZLxbJ
         dB4rqjEAbtZp6zboRIDNCuokcbRP2T7GJvG7XfhAdjDLv0mzmHP9V+OJbdfy+sGL91Ov
         pkUw==
X-Gm-Message-State: AJIora/jWqZ9mR8SIdX9me/+Z050GnuVD3XRrsz942KP4oMb+S6hr4s+
        2mmAKGY7lWacbmthvZVpFkVWpA==
X-Google-Smtp-Source: AGRyM1soYXdC5oJ5ngHCjBMOlNDXKj1DbPvYUU84uZKeKoHi0RWyqkp5nbIHwSkxb0eHPEuWxWBPrg==
X-Received: by 2002:a5d:604a:0:b0:21b:9517:66eb with SMTP id j10-20020a5d604a000000b0021b951766ebmr18124888wrt.494.1656431177792;
        Tue, 28 Jun 2022 08:46:17 -0700 (PDT)
Received: from localhost ([89.101.121.18])
        by smtp.gmail.com with ESMTPSA id az14-20020a05600c600e00b003a04c74efd1sm5613667wmb.21.2022.06.28.08.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 08:46:17 -0700 (PDT)
Date:   Tue, 28 Jun 2022 16:46:15 +0100
From:   Adam Sindelar <adam@wowsignal.io>
To:     Aneesh Kumar K V <aneesh.kumar@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, void@manifault.com, ats@fb.com,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: + selftests-vm-only-run-128tbswitch-with-5-level-paging.patch
 added to mm-unstable branch
Message-ID: <YrsiR9G+QYrufoMV@vroom.local>
References: <20220627185217.72065C3411D@smtp.kernel.org>
 <353afe7b-bf7c-59c4-134c-fe029da0f382@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <353afe7b-bf7c-59c4-134c-fe029da0f382@linux.ibm.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Jun 28, 2022 at 08:16:41PM +0530, Aneesh Kumar K V wrote:
> On 6/28/22 12:22 AM, Andrew Morton wrote:
> > The patch titled
> >      Subject: selftests/vm: Only run 128TBswitch with 5-level paging
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      selftests-vm-only-run-128tbswitch-with-5-level-paging.patch
> > 
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-only-run-128tbswitch-with-5-level-paging.patch
> > 
> > This patch will later appear in the mm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > 
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> > 
> > ------------------------------------------------------
> > From: Adam Sindelar <adam@wowsignal.io>
> > Subject: selftests/vm: Only run 128TBswitch with 5-level paging
> > Date: Mon, 27 Jun 2022 18:39:12 +0200
> > 
> > The test va_128TBswitch.c expects to be able to pass mmap an address hint
> > and length that cross the address 1<<47. This is not possible without
> > 5-level page tables, so the test fails.
> > 
> > The test is already only run on 64-bit powerpc and x86 archs, but this
> > patch adds an additional check that skips the test if PG_TABLE_LEVELS < 5.
> > There is precedent for checking /proc/config.gz in selftests, e.g. in
> > selftests/firmware.
> > 
> > Running the tests produces the desired output:
> > 
> > sudo make -C tools/testing/selftests TARGETS=vm run_tests
> > ---------------------------
> > running ./va_128TBswitch.sh
> > ---------------------------
> > ./va_128TBswitch.sh: PG_TABLE_LEVELS=4, must be >= 5 to run this test
> > [SKIP]
> > -------------------------------
> > 
> > Link: https://lkml.kernel.org/r/20220627163912.5581-1-adam@wowsignal.io
> > Signed-off-by: Adam Sindelar <adam@wowsignal.io>
> > Cc: Adam Sindelar <ats@fb.com>
> > Cc: David Vernet <void@manifault.com>
> > Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  tools/testing/selftests/vm/Makefile          |    1 
> >  tools/testing/selftests/vm/run_vmtests.sh    |    2 
> >  tools/testing/selftests/vm/va_128TBswitch.sh |   39 +++++++++++++++++
> >  3 files changed, 41 insertions(+), 1 deletion(-)
> > 
> > --- a/tools/testing/selftests/vm/Makefile~selftests-vm-only-run-128tbswitch-with-5-level-paging
> > +++ a/tools/testing/selftests/vm/Makefile
> > @@ -93,6 +93,7 @@ TEST_PROGS := run_vmtests.sh
> > 
> >  TEST_FILES := test_vmalloc.sh
> >  TEST_FILES += test_hmm.sh
> > +TEST_FILES += va_128TBswitch.sh
> > 
> >  KSFT_KHDR_INSTALL := 1
> >  include ../lib.mk
> > --- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-only-run-128tbswitch-with-5-level-paging
> > +++ a/tools/testing/selftests/vm/run_vmtests.sh
> > @@ -158,7 +158,7 @@ if [ $VADDR64 -ne 0 ]; then
> >  	run_test ./virtual_address_range
> > 
> >  	# virtual address 128TB switch test
> > -	run_test ./va_128TBswitch
> > +	run_test ./va_128TBswitch.sh
> >  fi # VADDR64
> > 
> >  # vmalloc stability smoke test
> > --- /dev/null
> > +++ a/tools/testing/selftests/vm/va_128TBswitch.sh
> > @@ -0,0 +1,39 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Copyright (C) 2022 Adam Sindelar (Meta) <adam@wowsignal.io>
> > +#
> > +# This is a test for mmap behavior with 5-level paging. This script wraps the
> > +# real test to check that the kernel is configured to support at least 5
> > +# pagetable levels.
> > +
> > +# 1 means the test failed
> > +exitcode=1
> > +
> > +# Kselftest framework requirement - SKIP code is 4.
> > +ksft_skip=4
> > +
> > +die()
> > +{
> > +    echo "$1"
> > +    exit $exitcode
> > +}
> > +
> > +check_test_requirements()
> > +{
> > +    local config="/proc/config.gz"
> > +    [[ -f "${config}" ]] || config="/boot/config-$(uname -r)"
> > +    [[ -f "${config}" ]] || die "Cannot find kernel config in /proc or /boot"
> > +
> > +    # gzip -dcfq automatically handles both compressed and plaintext input.
> > +    # See man 1 gzip under '-f'.
> > +    local pg_table_levels=$(gzip -dcfq "${config}" | grep PGTABLE_LEVELS | cut -d'=' -f 2)
> > +
> > +    if [[ "${pg_table_levels}" -lt 5 ]]; then
> > +        echo "$0: PG_TABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
> > +        exit $ksft_skip
> > +    fi
> > +}
> > +
> 
> What about architectures other than x86? Will this break on other architectures which don't support 
> PGTABLE_LEVELS ?
> 
> 

The test only runs on powerpc64 and x86_64. I didn't realize powerpc64
is using fewer pagetable levels. I am inclined to just change v4 so that
it checks the PGTABLE_LEVELS config on x86_64 and accepts any powerpc64,
because I don't know how to check whether a specific powerpc64 system
supports addresses over 1<<47. (The test already rejects all other
architectures.)

Does that seem reasonable?

> > +check_test_requirements
> > +./va_128TBswitch
> > _
> > 
> > Patches currently in -mm which might be from adam@wowsignal.io are
> > 
> > selftests-vm-only-run-128tbswitch-with-5-level-paging.patch
> > 
> 
