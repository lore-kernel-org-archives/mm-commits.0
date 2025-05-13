Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26F92EB1D
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747151910; cv=none; b=Fq/MffwRdHzqFw9EIEWtVNu5CZF03A+urB/nM1vQxLJ8AC2ymSafEkoCu5W4565US8iRFliL/EjefNbZ1HK6pcdYw/2spAZx0N2SozVujHJqaDUdmfAbylLwCYZQW+1G6gSSzUB7b5SGnCs/VH89CyGygiLI7MKPy/bumzveOqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747151910; c=relaxed/simple;
	bh=dqTxQLiwg4dssqXsIOQwGJB9o6mEMrzUjYyD5c1NKqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WMQclgymV1y1ddZ7Y0KP2XReLXFuXAMMQEM/VW1f/tCmdRXRil+rVOl6AU5DJbymvNDAQJmCwkF/SIAeT2fFD57HI6uk0OUpQ3p71UwnyvTy12vMtAuzvY8tjxCTW9673d0ovqnlbuVr8y4lAotQuOzgiYlGO279GCdZReeXxQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dTItRx4y; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dTItRx4y"
Date: Tue, 13 May 2025 08:58:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747151906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bnLpbCsY1Yfwl6RlRN06kVCy+ktSZP3gW03lm5NoX+k=;
	b=dTItRx4y/OSIl/kQ4BhBu6hAlbIWNCWzXul18iFqc7ZeL5HlXiSNdVdArS6GuE7iW5w8MB
	ZgHh9xqPQA1eMY3Xf2y87U0sEmxjaH7cU75avik46nRrCCzRc/QbmNSZ6amiZ6Ycw2jakZ
	JcrHkP+5Iqvm75nIjoPqt3cfc1qf7Cs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yang.yang29@zte.com.cn, 
	wang.yaxin@zte.com.cn, songmuchun@bytedance.com, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, mhocko@suse.com, mhocko@kernel.org, hannes@cmpxchg.org, 
	david@redhat.com, chen.haonan2@zte.com.cn, xu.xin16@zte.com.cn
Subject: Re: [merged mm-stable] memcontrol-rename-mem_cgroup_scan_tasks.patch
 removed from -mm tree
Message-ID: <36ptbmurx4fwsb5hpbnilojogsdx3fj4f7soywzw6ea4ve4cld@52yyggqaisot>
References: <20250513065531.D8D79C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513065531.D8D79C4CEE4@smtp.kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, May 12, 2025 at 11:55:31PM -0700, Andrew Morton wrote:
> 
> The quilt patch titled
>      Subject: memcontrol: rename mem_cgroup_scan_tasks()
> has been removed from the -mm tree.  Its filename was
>      memcontrol-rename-mem_cgroup_scan_tasks.patch
> 
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: xu xin <xu.xin16@zte.com.cn>
> Subject: memcontrol: rename mem_cgroup_scan_tasks()
> Date: Thu, 1 May 2025 04:11:34 +0000
> 
> With the enablement of container-level KSM (e.g., via prctl [1]), there is
> a growing demand for container-level observability of KSM behavior. 
> However, current cgroup implementations lack support for exposing
> KSM-related metrics.
> 
> This patchset introduces a new interface named ksm_stat at the cgroup
> hierarchy level, enabling users to monitor KSM merging statistics
> specifically for containers where this feature has been activated,
> eliminating the need to manually inspect KSM information for each
> individual process within the cgroup.
> 
> Users can obtain the KSM information of a cgroup just by:
> 
> # cat /sys/fs/cgroup/memory.ksm_stat
> ksm_rmap_items 76800
> ksm_zero_pages 0
> ksm_merging_pages 76800
> ksm_process_profit 309657600
> 
> This implementation supports both cgroup v2 and cgroup v1.
> 
> 
> This patch (of 9):
> 
> Current Issue:
> ==============
> mem_cgroup_scan_tasks in memcontrol.c has a naming ambiguity.  While its
> name suggests it only iterates through processes belonging to the current
> memcgroup, it actually scans all descendant cgroups under the subtree
> rooted at this memcgroup.  This discrepancy can cause confusion for
> developers relying on the semantic meaning of the function name.
> 
> Resolution:
> ===========
> Renaming: We have renamed the original function to
> **mem_cgroup_tree_scan_tasks** to explicitly reflect its subtree-traversal
> behavior.
> 
> A subsequent patch will introduce a new mem_cgroup_scan_tasks function
> that strictly iterates processes only within the current memcgroup,
> aligning its behavior with its name.
> 
> Link: https://lkml.kernel.org/r/20250501120854885LyBCW0syCGojqnJ8crLVl@zte.com.cn
> Link: https://lkml.kernel.org/r/20250501041134.3324145-1-xu.xin16@zte.com.cn
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
> Cc: Yang Yang <yang.yang29@zte.com.cn>
> Cc: Haonan Chen <chen.haonan2@zte.com.cn>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Hi Andrew, can you please keep this series on hold for now? The
discussion has not concluded yet. Mainly I want to see system level
metrics which can get included in memcg and exposed through memory.stat
interface instead of a new one.

thanks,
Shakeel
