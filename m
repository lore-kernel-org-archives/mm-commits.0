Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DCEC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 06:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241780AbiDZGMm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 02:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244839AbiDZGMe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 02:12:34 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDC8A12ACDB
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 23:09:27 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A5E723A;
        Mon, 25 Apr 2022 23:09:27 -0700 (PDT)
Received: from [192.168.225.134] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97AA83F5A1;
        Mon, 25 Apr 2022 23:09:25 -0700 (PDT)
Message-ID: <e9eaca9f-7392-54d7-ef92-ecdb2fbfb91d@arm.com>
Date:   Tue, 26 Apr 2022 11:40:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: +
 mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch added
 to -mm tree
Content-Language: en-US
To:     =?UTF-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "bp@alien8.de" <bp@alien8.de>, Yu Xu <xuyu@linux.alibaba.com>
References: <20220425221516.561D0C385A4@smtp.kernel.org>
 <20220426000024.GA3828305@hori.linux.bs1.fc.nec.co.jp>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20220426000024.GA3828305@hori.linux.bs1.fc.nec.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Naoya,

On 4/26/22 05:30, HORIGUCHI NAOYA(堀口 直也) wrote:
> Hi,
> 
> Thank you for working on this.  This patch depends on commit d173d5417fb6
> ("mm/memory-failure.c: skip huge_zero_page in memory_failure()") which was a
> bit prematurely merged into mainline.  The proposer would like to submit
> another version of fix in the agreed approach, and d173d5417fb6 will be
> likely to be reverted.  So could you drop this patch from linux-mm for now
> to avoid the confusion due to the conflict.

I am happy to resend this patch after all the stated above.

> 
> Thanks,
> Naoya Horiguchi
> 
> On Mon, Apr 25, 2022 at 03:15:15PM -0700, Andrew Morton wrote:
>>
>> The patch titled
>>      Subject: mm/memory-failure: add new memory failure message MF_MSG_HUGE_ZERO
>> has been added to the -mm tree.  Its filename is
>>      mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch
>>
>> This patch should soon appear at
>>     https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch
>> and later at
>>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch
>>
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>
>> The -mm tree is included into linux-next and is updated
>> there every 3-4 working days
>>
>> ------------------------------------------------------
>> From: Anshuman Khandual <anshuman.khandual@arm.com>
>> Subject: mm/memory-failure: add new memory failure message MF_MSG_HUGE_ZERO
>>
>> Memory failure just gets ignored for global huge_zero_page even without a
>> split attempt.  But corresponding memory failure message
>> MF_MSG_UNSPLIT_THP is misleading as if the THP page could not be split
>> during memory failure handling.  This adds a new message MF_MSG_HUGE_ZERO
>> indicating that memory got ignored for being a huge zero page.
>>
>> Link: https://lkml.kernel.org/r/20220425080306.1771480-1-anshuman.khandual@arm.com
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  include/linux/mm.h      |    1 +
>>  include/ras/ras_event.h |    1 +
>>  mm/memory-failure.c     |    3 ++-
>>  3 files changed, 4 insertions(+), 1 deletion(-)
>>
>> --- a/include/linux/mm.h~mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero
>> +++ a/include/linux/mm.h
>> @@ -3275,6 +3275,7 @@ enum mf_action_page_type {
>>  	MF_MSG_SLAB,
>>  	MF_MSG_DIFFERENT_COMPOUND,
>>  	MF_MSG_HUGE,
>> +	MF_MSG_HUGE_ZERO,
>>  	MF_MSG_FREE_HUGE,
>>  	MF_MSG_NON_PMD_HUGE,
>>  	MF_MSG_UNMAP_FAILED,
>> --- a/include/ras/ras_event.h~mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero
>> +++ a/include/ras/ras_event.h
>> @@ -359,6 +359,7 @@ TRACE_EVENT(aer_event,
>>  	EM ( MF_MSG_SLAB, "kernel slab page" )				\
>>  	EM ( MF_MSG_DIFFERENT_COMPOUND, "different compound page after locking" ) \
>>  	EM ( MF_MSG_HUGE, "huge page" )					\
>> +	EM ( MF_MSG_HUGE_ZERO, "huge zero page" )			\
>>  	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
>>  	EM ( MF_MSG_NON_PMD_HUGE, "non-pmd-sized huge page" )		\
>>  	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
>> --- a/mm/memory-failure.c~mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero
>> +++ a/mm/memory-failure.c
>> @@ -719,6 +719,7 @@ static const char * const action_page_ty
>>  	[MF_MSG_SLAB]			= "kernel slab page",
>>  	[MF_MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
>>  	[MF_MSG_HUGE]			= "huge page",
>> +	[MF_MSG_HUGE_ZERO]		= "huge zero page",
>>  	[MF_MSG_FREE_HUGE]		= "free huge page",
>>  	[MF_MSG_NON_PMD_HUGE]		= "non-pmd-sized huge page",
>>  	[MF_MSG_UNMAP_FAILED]		= "unmapping failed page",
>> @@ -1859,7 +1860,7 @@ try_again:
>>  		 * TODO: Handle memory failure of huge_zero_page thoroughly.
>>  		 */
>>  		if (is_huge_zero_page(hpage)) {
>> -			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
>> +			action_result(pfn, MF_MSG_HUGE_ZERO, MF_IGNORED);
>>  			res = -EBUSY;
>>  			goto unlock_mutex;
>>  		}
>> _
>>
>> Patches currently in -mm which might be from anshuman.khandual@arm.com are
>>
>> mm-debug_vm_pgtable-drop-protection_map-usage.patch
>> mm-mmap-clarify-protection_map-indices.patch
>> mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch
>> powerpc-mm-enable-arch_has_vm_get_page_prot.patch
>> arm64-mm-enable-arch_has_vm_get_page_prot.patch
>> sparc-mm-enable-arch_has_vm_get_page_prot.patch
>> mm-mmap-drop-arch_filter_pgprot.patch
>> mm-mmap-drop-arch_vm_get_page_pgprot.patch
>> mm-memory-failure-add-new-memory-failure-message-mf_msg_huge_zero.patch
