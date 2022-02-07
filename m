Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A78C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 08:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243765AbiBGIlu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 03:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345482AbiBGIdS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 03:33:18 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 00:33:18 PST
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EC3C043181
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 00:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644222798; x=1675758798;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=st4wTbqnfe8/mBeekfXuiOPVETSNLYzBUQmdsLF+6k4=;
  b=QeDmcRgZ2EaqA++DAPawa41O+d9RWy3pOLlcDpfSFGWecBKIxXSDOdV3
   MuOi+iR2Ks/lzOy/VyKVrszAr82ERdm3lgikZpV+kkuzOVXffP4Bw9FaQ
   OVhGxeF1L6hwVG6KVCGldeKHf47YaMxF56Q/iB6jz/AvRm8AsmBRQRkPP
   Kg8TNp6VBqTrkULed1flzuYgFsaNndEUzWWU3/AnWbSHCRXMwdf0JerF2
   jkakzney1KghsXXEQz6Vq8IHyezlH/CQsSM4qxX7ZeJA5ncmo+hV+Lx6i
   rWNQ+k0Ox02BhP6qZX7CMEAnkDdHw9fWUDM+nS8UYcTZR87Bm9a3d62C9
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10250"; a="228641796"
X-IronPort-AV: E=Sophos;i="5.88,349,1635231600"; 
   d="scan'208";a="228641796"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 00:32:16 -0800
X-IronPort-AV: E=Sophos;i="5.88,349,1635231600"; 
   d="scan'208";a="540002966"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.239.13.11])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 00:32:12 -0800
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, ziy@nvidia.com,
        zhongjiang-ali@linux.alibaba.com, weixugc@google.com,
        shy828301@gmail.com, shakeelb@google.com, riel@surriel.com,
        osalvador@suse.de, mhocko@suse.com, mgorman@techsingularity.net,
        hasanalmaruf@fb.com, feng.tang@intel.com,
        dave.hansen@linux.intel.com, baolin.wang@linux.alibaba.com
Subject: Re: +
 numa-balancing-optimize-page-placement-for-memory-tiering-system.patch
 added to -mm tree
References: <20220201222010.E9F39C340EB@smtp.kernel.org>
        <20220202101926.GY20638@worktop.programming.kicks-ass.net>
Date:   Mon, 07 Feb 2022 16:32:10 +0800
In-Reply-To: <20220202101926.GY20638@worktop.programming.kicks-ass.net> (Peter
        Zijlstra's message of "Wed, 2 Feb 2022 11:19:26 +0100")
Message-ID: <87leynm60l.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Feb 01, 2022 at 02:20:10PM -0800, Andrew Morton wrote:
>> 
>> The patch titled
>>      Subject: NUMA balancing: optimize page placement for memory tiering system
>> has been added to the -mm tree.  Its filename is
>>      numa-balancing-optimize-page-placement-for-memory-tiering-system.patch
>> 
>> This patch should soon appear at
>>     https://ozlabs.org/~akpm/mmots/broken-out/numa-balancing-optimize-page-placement-for-memory-tiering-system.patch
>> and later at
>>     https://ozlabs.org/~akpm/mmotm/broken-out/numa-balancing-optimize-page-placement-for-memory-tiering-system.patch
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
>> From: Huang Ying <ying.huang@intel.com>
>> Subject: NUMA balancing: optimize page placement for memory tiering system
>
> I'm thinking this is a bit soon, current stuff is all sorts of broken
> in the presence of memory only nodes.
>
> I *really* want to see all that fixed before we merge this stuff.

Hi, Peter,

I am working on the fixing now.  And I will try my best to fix it as
soon as possible.

Best Regards,
Huang, Ying]
