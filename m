Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51A2C48BE6
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 12:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B149C61208
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 12:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhFNMjq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 08:39:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232775AbhFNMjq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 08:39:46 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15ECXStj191501;
        Mon, 14 Jun 2021 08:37:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=cu4/MD0c+IVUz5kaHSrupuanAgXaZUSXPflOf/xWYAI=;
 b=a47eL7/gDUQV4LyUuWCAsL6Wqs769Dh1z21rKsUJbS5PpUpjtATtJE9teCt0/T1ECKmd
 F19KJZjLO6/D3X0l6kSxtis0RcYkC5PQZsR84du+bl6xb8Xo7KFZk5+q7lU46235f4mc
 wrWlJpF9vNoWTkr4ZV7PZ6gBF6BB7daENqYVVk18YhNidcyiEe3MIqzDDZMpHhtztV5X
 QFHYEI8BJmA0QrepoS3TCVuRrrkgZMxOXe1Tj/uhq6HbNurID30ljIC1No9H8izMHPQD
 uyuMaEYRK2XmBIt1xoXTLYdPxzm7WtKofnah6faqaEEewZCn/bA0Y2ElnbgtGdF+mfIj fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39671agf85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 08:37:29 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15ECYRUk194478;
        Mon, 14 Jun 2021 08:37:28 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39671agf6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 08:37:28 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15ECWnB4011806;
        Mon, 14 Jun 2021 12:37:26 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 394m6h8gy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 12:37:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15ECbNPd35520960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 12:37:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 586624C044;
        Mon, 14 Jun 2021 12:37:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C90214C040;
        Mon, 14 Jun 2021 12:37:22 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.91.122])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Jun 2021 12:37:22 +0000 (GMT)
Subject: Re: + kvm-s390-fix-for-hugepage-vmalloc.patch added to -mm tree
To:     Nicholas Piggin <npiggin@gmail.com>, akpm@linux-foundation.org,
        catalin.marinas@arm.com, david@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        tglx@linutronix.de, urezki@gmail.com
References: <20210608210623.oyQ1Gh4H3%akpm@linux-foundation.org>
 <1623631892.c5eaco2ojh.astroid@bobo.none>
 <1623632435.4kfx35vz3e.astroid@bobo.none>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <620a97e6-a94d-af5c-bc69-57a8b747b001@de.ibm.com>
Date:   Mon, 14 Jun 2021 14:37:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <1623632435.4kfx35vz3e.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: weOBFO1117F3w5bu16agT1_mYUCOidGi
X-Proofpoint-ORIG-GUID: pydr1BLX32EK1HihS9Tg9sumr6kXrJRa
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_07:2021-06-14,2021-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106140086
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 14.06.21 03:13, Nicholas Piggin wrote:
> Excerpts from Nicholas Piggin's message of June 14, 2021 10:58 am:
>> Excerpts from akpm@linux-foundation.org's message of June 9, 2021 7:06 am:
>>>
>>> The patch titled
>>>       Subject: KVM: s390: fix for hugepage vmalloc
>>> has been added to the -mm tree.  Its filename is
>>>       kvm-s390-fix-for-hugepage-vmalloc.patch
>>>
>>> This patch should soon appear at
>>>      https://ozlabs.org/~akpm/mmots/broken-out/kvm-s390-fix-for-hugepage-vmalloc.patch
>>> and later at
>>>      https://ozlabs.org/~akpm/mmotm/broken-out/kvm-s390-fix-for-hugepage-vmalloc.patch
>>>
>>> Before you just go and hit "reply", please:
>>>     a) Consider who else should be cc'ed
>>>     b) Prefer to cc a suitable mailing list as well
>>>     c) Ideally: find the original patch on the mailing list and do a
>>>        reply-to-all to that, adding suitable additional cc's
>>>
>>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>>
>>> The -mm tree is included into linux-next and is updated
>>> there every 3-4 working days
>>>
>>> ------------------------------------------------------
>>> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Subject: KVM: s390: fix for hugepage vmalloc
>>>
>>> The Create Secure Configuration Ultravisor Call does not support using
>>> large pages for the virtual memory area.  This is a hardware limitation.
>>>
>>> This patch replaces the vzalloc call with a longer but equivalent
>>> __vmalloc_node_range call, also setting the VM_NO_HUGE_VMAP flag, to
>>> guarantee that this allocation will not be performed with large pages.
>>>
>>> Link: https://lkml.kernel.org/r/20210608180618.477766-3-imbrenda@linux.ibm.com
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>>> Fixes: 121e6f3258fe393e22c3 ("mm/vmalloc: hugepage vmalloc mappings")
>>
>> Hmm, s390 does not select HAVE_ARCH_HUGE_VMALLOC so it was intended that
>> "mm/vmalloc: hugepage vmalloc mappings" does not introduce huge vmallocs
>> for you.
>>
>> I can't see how this would happen, any clue what I'm missing?
> 
> Ah, read into the mailing list thread for the other patch and it seems
> it only becomes a problem if/when you do enable it, is that right?
> 
>  From the changelog it appears that this fixes a bug introduced by that
> patch. I think instead it should go with the series that enables the
> option, and without the fixes tag.
> 
> Or if you wanted to get this core API change in first and need a caller
> in-tree, explain in the changelog that huge vmalloc enablement is coming
> later and requires it. The enable patch that comes later could reference
> this commit to help with backporting, if that's what you are concerned
> about.

Yes, its an ordering thing. Before s390 can opt in, we need to get our "odd
cases fixed". Not sure if we need a new version with a different description
or if we can simply leave it as is?
