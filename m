Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFADAC43334
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 15:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiF1PyJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 11:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiF1PyI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 11:54:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705B82EA08
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 08:54:06 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SFlOSO026173;
        Tue, 28 Jun 2022 15:54:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=HxmIv4VAE2raSwGxUn0UrKkx/PuPKT7FcYeN2e3AJQI=;
 b=eB32B7+9NC2snKJzF51vgqHKM1X97FSrr4RPX3thlxupiU0aIwYePmoME2euoYcCuz8d
 9YUC1G46BrAiOAcsvUv3S07fk7UqRJ0Lb3mvXgQCH06MhhXPzhH5B09/pHnx7tVCq8sn
 EBBEoXrqIlLbEPZP1j8WlKi8xXVB5rNca9D/dz2iyoHjyUhw9Q14lSgBgAutrloJzwu4
 svscjKhsDLqKS1LTe+RDcfn2Fc6JI/VHXNCCO587ExzR5lYDEu5o/yMWQd4Ikp8tsDFo
 gmq1rCcmaDNqc2AipXgb98JwyOIKhJd8WhAwDN9CgZQYqr1jMgfEi9Mj/phwJNQq31FS TA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h04kjg61g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 15:54:03 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SFpDOY005426;
        Tue, 28 Jun 2022 15:54:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3gwt08w3nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 15:54:00 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SFs5cR31719764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 15:54:05 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A994152050;
        Tue, 28 Jun 2022 15:53:58 +0000 (GMT)
Received: from [9.43.29.251] (unknown [9.43.29.251])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AADCF5204E;
        Tue, 28 Jun 2022 15:53:56 +0000 (GMT)
Message-ID: <cbbf1cfb-2cde-f8d5-c193-47bbaaa5062c@linux.ibm.com>
Date:   Tue, 28 Jun 2022 21:23:55 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: + selftests-vm-only-run-128tbswitch-with-5-level-paging.patch
 added to mm-unstable branch
Content-Language: en-US
To:     Adam Sindelar <adam@wowsignal.io>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, void@manifault.com, ats@fb.com,
        aneesh.kumar@linux.vnet.ibm.com
References: <20220627185217.72065C3411D@smtp.kernel.org>
 <353afe7b-bf7c-59c4-134c-fe029da0f382@linux.ibm.com>
 <YrsiR9G+QYrufoMV@vroom.local>
From:   Aneesh Kumar K V <aneesh.kumar@linux.ibm.com>
In-Reply-To: <YrsiR9G+QYrufoMV@vroom.local>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3zOazKQFwWa5rcUUsJBnDdZafpUcDKm1
X-Proofpoint-ORIG-GUID: 3zOazKQFwWa5rcUUsJBnDdZafpUcDKm1
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280063
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 6/28/22 9:16 PM, Adam Sindelar wrote:
> On Tue, Jun 28, 2022 at 08:16:41PM +0530, Aneesh Kumar K V wrote:
>> On 6/28/22 12:22 AM, Andrew Morton wrote:
>>> The patch titled
>>>      Subject: selftests/vm: Only run 128TBswitch with 5-level paging
>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>      selftests-vm-only-run-128tbswitch-with-5-level-paging.patch
>>>
>>> This patch will shortly appear at
>>>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-only-run-128tbswitch-with-5-level-paging.patch
>>>
>>> This patch will later appear in the mm-unstable branch at
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>
>>> Before you just go and hit "reply", please:
>>>    a) Consider who else should be cc'ed
>>>    b) Prefer to cc a suitable mailing list as well
>>>    c) Ideally: find the original patch on the mailing list and do a
>>>       reply-to-all to that, adding suitable additional cc's
>>>
>>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>>
>>> The -mm tree is included into linux-next via the mm-everything
>>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>> and is updated there every 2-3 working days
>>>
>>> ------------------------------------------------------
>>> From: Adam Sindelar <adam@wowsignal.io>
>>> Subject: selftests/vm: Only run 128TBswitch with 5-level paging
>>> Date: Mon, 27 Jun 2022 18:39:12 +0200
>>>
>>> The test va_128TBswitch.c expects to be able to pass mmap an address hint
>>> and length that cross the address 1<<47. This is not possible without
>>> 5-level page tables, so the test fails.
>>>
>>> The test is already only run on 64-bit powerpc and x86 archs, but this
>>> patch adds an additional check that skips the test if PG_TABLE_LEVELS < 5.
>>> There is precedent for checking /proc/config.gz in selftests, e.g. in
>>> selftests/firmware.
>>>
>>> Running the tests produces the desired output:
>>>
>>> sudo make -C tools/testing/selftests TARGETS=vm run_tests
>>> ---------------------------
>>> running ./va_128TBswitch.sh
>>> ---------------------------
>>> ./va_128TBswitch.sh: PG_TABLE_LEVELS=4, must be >= 5 to run this test
>>> [SKIP]
>>> -------------------------------
>>>
>>> Link: https://lkml.kernel.org/r/20220627163912.5581-1-adam@wowsignal.io
>>> Signed-off-by: Adam Sindelar <adam@wowsignal.io>
>>> Cc: Adam Sindelar <ats@fb.com>
>>> Cc: David Vernet <void@manifault.com>
>>> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>> ---
>>>
>>>  tools/testing/selftests/vm/Makefile          |    1 
>>>  tools/testing/selftests/vm/run_vmtests.sh    |    2 
>>>  tools/testing/selftests/vm/va_128TBswitch.sh |   39 +++++++++++++++++
>>>  3 files changed, 41 insertions(+), 1 deletion(-)
>>>
>>> --- a/tools/testing/selftests/vm/Makefile~selftests-vm-only-run-128tbswitch-with-5-level-paging
>>> +++ a/tools/testing/selftests/vm/Makefile
>>> @@ -93,6 +93,7 @@ TEST_PROGS := run_vmtests.sh
>>>
>>>  TEST_FILES := test_vmalloc.sh
>>>  TEST_FILES += test_hmm.sh
>>> +TEST_FILES += va_128TBswitch.sh
>>>
>>>  KSFT_KHDR_INSTALL := 1
>>>  include ../lib.mk
>>> --- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-only-run-128tbswitch-with-5-level-paging
>>> +++ a/tools/testing/selftests/vm/run_vmtests.sh
>>> @@ -158,7 +158,7 @@ if [ $VADDR64 -ne 0 ]; then
>>>  	run_test ./virtual_address_range
>>>
>>>  	# virtual address 128TB switch test
>>> -	run_test ./va_128TBswitch
>>> +	run_test ./va_128TBswitch.sh
>>>  fi # VADDR64
>>>
>>>  # vmalloc stability smoke test
>>> --- /dev/null
>>> +++ a/tools/testing/selftests/vm/va_128TBswitch.sh
>>> @@ -0,0 +1,39 @@
>>> +#!/bin/bash
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +#
>>> +# Copyright (C) 2022 Adam Sindelar (Meta) <adam@wowsignal.io>
>>> +#
>>> +# This is a test for mmap behavior with 5-level paging. This script wraps the
>>> +# real test to check that the kernel is configured to support at least 5
>>> +# pagetable levels.
>>> +
>>> +# 1 means the test failed
>>> +exitcode=1
>>> +
>>> +# Kselftest framework requirement - SKIP code is 4.
>>> +ksft_skip=4
>>> +
>>> +die()
>>> +{
>>> +    echo "$1"
>>> +    exit $exitcode
>>> +}
>>> +
>>> +check_test_requirements()
>>> +{
>>> +    local config="/proc/config.gz"
>>> +    [[ -f "${config}" ]] || config="/boot/config-$(uname -r)"
>>> +    [[ -f "${config}" ]] || die "Cannot find kernel config in /proc or /boot"
>>> +
>>> +    # gzip -dcfq automatically handles both compressed and plaintext input.
>>> +    # See man 1 gzip under '-f'.
>>> +    local pg_table_levels=$(gzip -dcfq "${config}" | grep PGTABLE_LEVELS | cut -d'=' -f 2)
>>> +
>>> +    if [[ "${pg_table_levels}" -lt 5 ]]; then
>>> +        echo "$0: PG_TABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
>>> +        exit $ksft_skip
>>> +    fi
>>> +}
>>> +
>>
>> What about architectures other than x86? Will this break on other architectures which don't support 
>> PGTABLE_LEVELS ?
>>
>>
> 
> The test only runs on powerpc64 and x86_64. I didn't realize powerpc64
> is using fewer pagetable levels. I am inclined to just change v4 so that
> it checks the PGTABLE_LEVELS config on x86_64 and accepts any powerpc64,
> because I don't know how to check whether a specific powerpc64 system
> supports addresses over 1<<47. (The test already rejects all other
> architectures.)
> 
> Does that seem reasonable?

I would suggest restricting the new check to only x86

-aneesh
