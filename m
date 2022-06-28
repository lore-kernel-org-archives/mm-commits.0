Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F05C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 14:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347153AbiF1Oq5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 10:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346214AbiF1Oqx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 10:46:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40502E9E2
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 07:46:51 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SEipML020898;
        Tue, 28 Jun 2022 14:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=cOxBsTKQWQmZlr82h8jJH3vqe+FvA7DfeKButoh8tpw=;
 b=Qbfqe67g4LwD0oBitsiyVr9Gsaul0gQwGwW/9zD8aIvwggJadeWRXKwY/JKZftzXzHZW
 VOR5uj3O6bo3y5abAKhxPT/D+LA1ZQsB2u3qa77y1z6zBDMZyxngHK36Xjj8IfHRpEN8
 z/CJGfpWuzZxGRPOf05Ebn7hj9ILUVqSNv8hgdvQrD+1sAzUFJQ/bsSkE1JxVHEmH8Kx
 //vIM8qmBPT3lNj6ep60XglASXheAXCMvSEYjFIgw2RE7Ri1mSvI/4jlARCSz3h9wAlB
 FzMbSuhNr848mMjs3h3VyaArsvwOHksWmAbj6aUpZohkihoFyYIpXAog5W4YREbc57UF 3g== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h03nyg2sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 14:46:49 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SEagPQ020660;
        Tue, 28 Jun 2022 14:46:47 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3gwt08w1c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 14:46:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SEkj8r24314314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 14:46:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDE4A5205F;
        Tue, 28 Jun 2022 14:46:44 +0000 (GMT)
Received: from [9.43.29.251] (unknown [9.43.29.251])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EFB2A52050;
        Tue, 28 Jun 2022 14:46:42 +0000 (GMT)
Message-ID: <353afe7b-bf7c-59c4-134c-fe029da0f382@linux.ibm.com>
Date:   Tue, 28 Jun 2022 20:16:41 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: + selftests-vm-only-run-128tbswitch-with-5-level-paging.patch
 added to mm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, void@manifault.com, ats@fb.com,
        aneesh.kumar@linux.vnet.ibm.com, adam@wowsignal.io
References: <20220627185217.72065C3411D@smtp.kernel.org>
From:   Aneesh Kumar K V <aneesh.kumar@linux.ibm.com>
In-Reply-To: <20220627185217.72065C3411D@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hr7fnVkQEeY6Tn5JPYMr_B07zVkLpMRk
X-Proofpoint-GUID: hr7fnVkQEeY6Tn5JPYMr_B07zVkLpMRk
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 priorityscore=1501 clxscore=1011 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280061
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 6/28/22 12:22 AM, Andrew Morton wrote:
> The patch titled
>      Subject: selftests/vm: Only run 128TBswitch with 5-level paging
> has been added to the -mm mm-unstable branch.  Its filename is
>      selftests-vm-only-run-128tbswitch-with-5-level-paging.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-only-run-128tbswitch-with-5-level-paging.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Adam Sindelar <adam@wowsignal.io>
> Subject: selftests/vm: Only run 128TBswitch with 5-level paging
> Date: Mon, 27 Jun 2022 18:39:12 +0200
> 
> The test va_128TBswitch.c expects to be able to pass mmap an address hint
> and length that cross the address 1<<47. This is not possible without
> 5-level page tables, so the test fails.
> 
> The test is already only run on 64-bit powerpc and x86 archs, but this
> patch adds an additional check that skips the test if PG_TABLE_LEVELS < 5.
> There is precedent for checking /proc/config.gz in selftests, e.g. in
> selftests/firmware.
> 
> Running the tests produces the desired output:
> 
> sudo make -C tools/testing/selftests TARGETS=vm run_tests
> ---------------------------
> running ./va_128TBswitch.sh
> ---------------------------
> ./va_128TBswitch.sh: PG_TABLE_LEVELS=4, must be >= 5 to run this test
> [SKIP]
> -------------------------------
> 
> Link: https://lkml.kernel.org/r/20220627163912.5581-1-adam@wowsignal.io
> Signed-off-by: Adam Sindelar <adam@wowsignal.io>
> Cc: Adam Sindelar <ats@fb.com>
> Cc: David Vernet <void@manifault.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  tools/testing/selftests/vm/Makefile          |    1 
>  tools/testing/selftests/vm/run_vmtests.sh    |    2 
>  tools/testing/selftests/vm/va_128TBswitch.sh |   39 +++++++++++++++++
>  3 files changed, 41 insertions(+), 1 deletion(-)
> 
> --- a/tools/testing/selftests/vm/Makefile~selftests-vm-only-run-128tbswitch-with-5-level-paging
> +++ a/tools/testing/selftests/vm/Makefile
> @@ -93,6 +93,7 @@ TEST_PROGS := run_vmtests.sh
> 
>  TEST_FILES := test_vmalloc.sh
>  TEST_FILES += test_hmm.sh
> +TEST_FILES += va_128TBswitch.sh
> 
>  KSFT_KHDR_INSTALL := 1
>  include ../lib.mk
> --- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-only-run-128tbswitch-with-5-level-paging
> +++ a/tools/testing/selftests/vm/run_vmtests.sh
> @@ -158,7 +158,7 @@ if [ $VADDR64 -ne 0 ]; then
>  	run_test ./virtual_address_range
> 
>  	# virtual address 128TB switch test
> -	run_test ./va_128TBswitch
> +	run_test ./va_128TBswitch.sh
>  fi # VADDR64
> 
>  # vmalloc stability smoke test
> --- /dev/null
> +++ a/tools/testing/selftests/vm/va_128TBswitch.sh
> @@ -0,0 +1,39 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Copyright (C) 2022 Adam Sindelar (Meta) <adam@wowsignal.io>
> +#
> +# This is a test for mmap behavior with 5-level paging. This script wraps the
> +# real test to check that the kernel is configured to support at least 5
> +# pagetable levels.
> +
> +# 1 means the test failed
> +exitcode=1
> +
> +# Kselftest framework requirement - SKIP code is 4.
> +ksft_skip=4
> +
> +die()
> +{
> +    echo "$1"
> +    exit $exitcode
> +}
> +
> +check_test_requirements()
> +{
> +    local config="/proc/config.gz"
> +    [[ -f "${config}" ]] || config="/boot/config-$(uname -r)"
> +    [[ -f "${config}" ]] || die "Cannot find kernel config in /proc or /boot"
> +
> +    # gzip -dcfq automatically handles both compressed and plaintext input.
> +    # See man 1 gzip under '-f'.
> +    local pg_table_levels=$(gzip -dcfq "${config}" | grep PGTABLE_LEVELS | cut -d'=' -f 2)
> +
> +    if [[ "${pg_table_levels}" -lt 5 ]]; then
> +        echo "$0: PG_TABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
> +        exit $ksft_skip
> +    fi
> +}
> +

What about architectures other than x86? Will this break on other architectures which don't support 
PGTABLE_LEVELS ?


> +check_test_requirements
> +./va_128TBswitch
> _
> 
> Patches currently in -mm which might be from adam@wowsignal.io are
> 
> selftests-vm-only-run-128tbswitch-with-5-level-paging.patch
> 

