Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648DA2D061E
	for <mm-commits@vger.kernel.org>; Fri, 17 Oct 2025 23:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760743614; cv=none; b=EV7/QAbzfi0bMwzNy39LCH0gqCoC4Sdd8lwqd77q1Tuli+4aW1puLiNCbjDym47gFj3TKSSJZ4KvlC21RJWHay+HReY2HdvAtaS09cTV9/KrVXWUrMo6DKQG/Y4gT/FCABMGhfHu7PrINyNeQRYl2UPSe6iPpgGpvUvaac9AQfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760743614; c=relaxed/simple;
	bh=Mgy19bMcoX3noUuAuh914ceElQDQUTFCDjbpnfomEoo=;
	h=Date:To:From:Subject:Message-Id; b=QZVl04ZhR1XsWG1TpuJJWGTSVFLFjbdjAwe33/JBjs3Mua5kPqEroGLUq4Z/aqIN/6dfs4ItX5AXtCJY3LhnWgN8xNktih7eL+3qxSGX4GFgZjyCJjvR4ch7Wb26GlN9ratA79ow7de1CPrB97J7/klc7y526t3OMsLCjJ2r8tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uYAEOfBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uYAEOfBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28EAC4CEE7;
	Fri, 17 Oct 2025 23:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760743613;
	bh=Mgy19bMcoX3noUuAuh914ceElQDQUTFCDjbpnfomEoo=;
	h=Date:To:From:Subject:From;
	b=uYAEOfBK1Bp9Bt1hVfDQvT+BFF1rRrnuxKqpnvoj2lqqmZxWMKIqjQqbnY73ju3R7
	 1t7ZbkchXvL1ShTnTESLDIiu/lvE4uBXamyFSgFQ6NSuNphCOgUkZMzzDE330tak95
	 v3eWJTn0kJ1isZgWQdMvfK7v7Sz/dN3ZH2CUtsuE=
Date: Fri, 17 Oct 2025 16:26:53 -0700
To: mm-commits@vger.kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-node-fold-unregister_node-into-unregister_one_node-fix.patch added to mm-unstable branch
Message-Id: <20251017232653.B28EAC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Re: drivers/base/node: Fold unregister_node() into unregister_one_node()
has been added to the -mm mm-unstable branch.  Its filename is
     drivers-base-node-fold-unregister_node-into-unregister_one_node-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-node-fold-unregister_node-into-unregister_one_node-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: Re: drivers/base/node: Fold unregister_node() into unregister_one_node()
Date: Fri, 17 Oct 2025 10:47:43 +0530

This is a multi-part message in MIME format.
--------------lEjR0iPOz9KnyL9ZWgMzVvbr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/15/25 10:57 PM, SeongJae Park wrote:
> On Tue, 14 Oct 2025 21:09:17 +0530 Donet Tom<donettom@linux.ibm.com> wrote:
>
>> The function unregister_node() is only called from unregister_one_node().
>> This patch folds unregister_node() into its only caller and renames
>> unregister_one_node() to unregister_node().
>>
>> This reduces unnecessary indirection and simplifies the code structure.
>> No functional changes are introduced.
>>
>> Acked-by: David Hildenbrand<david@redhat.com>
>> Acked-by: Mike Rapoport (Microsoft)<rppt@kernel.org>
>> Signed-off-by: Donet Tom<donettom@linux.ibm.com>
> Acked-by: SeongJae Park<sj@kernel.org>
>
>> ---
>>   drivers/base/node.c  | 38 +++++++++++++++++---------------------
>>   include/linux/node.h |  6 ++----
>>   mm/memory_hotplug.c  |  4 ++--
>>   3 files changed, 21 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index 4bcaa8006cd6..758b777dec1f 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -676,23 +676,6 @@ static void node_device_release(struct device *dev)
>>   	kfree(to_node(dev));
>>   }
>>
>> -/**
>> - * unregister_node - unregister a node device
>> - * @node: node going away
>> - *
>> - * Unregisters a node device @node.  All the devices on the node must be
>> - * unregistered before calling this function.
>> - */
>> -void unregister_node(struct node *node)
>> -{
>> -	hugetlb_unregister_node(node);
>> -	compaction_unregister_node(node);
>> -	reclaim_unregister_node(node);
>> -	node_remove_accesses(node);
>> -	node_remove_caches(node);
>> -	device_unregister(&node->dev);
>> -}
>> -
>>   struct node *node_devices[MAX_NUMNODES];
>>
>>   /*
>> @@ -924,13 +907,26 @@ int register_node(int nid)
>>
>>   	return error;
>>   }
>> -
>> -void unregister_one_node(int nid)
>> +/**
>> + * unregister_node - unregister a node device
>> + * @nid: nid of the node going away
>> + *
>> + * Unregisters the node device at node id  @nid.  All the devices on the
> Nit.  Why two spaces before "@nid"?

Thank you for pointing this out.

Andrew could you please help apply the below fixlet on top of this patch?

 From 0d0345847ad33607c7ebae3798ef37ff16a20fd0 Mon Sep 17 00:00:00 2001
Date: Fri, 17 Oct 2025 10:27:54 +0530
Subject: [PATCH] [fixlet] drivers/base/node: Remove extra space in description

This patch removes an extra space before @nid and "All".

Link: https://lkml.kernel.org/r/cff01514-9074-4c97-bcf1-d4e3594e48b0@linux.ibm.com
Signed-off-by: Donet Tom<donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/node.c~drivers-base-node-fold-unregister_node-into-unregister_one_node-fix
+++ a/drivers/base/node.c
@@ -911,7 +911,7 @@ int register_node(int nid)
  * unregister_node - unregister a node device
  * @nid: nid of the node going away
  *
- * Unregisters the node device at node id  @nid.  All the devices on the
+ * Unregisters the node device at node id @nid. All the devices on the
  * node must be unregistered before calling this function.
  */
 void unregister_node(int nid)
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

drivers-base-node-fold-register_node-into-register_one_node.patch
drivers-base-node-fold-unregister_node-into-unregister_one_node.patch
drivers-base-node-fold-unregister_node-into-unregister_one_node-fix.patch

