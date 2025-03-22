Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8FE156653
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619844; cv=none; b=pyyqWyCWIP3la7opVU/TPt/1mlnoAW/4YGZaF5z1B7Yc0h/FSMuPfWtUglnf1UdUSeuBq0pHf5KmVKN+OaO7ifdcsEB7v9y5LKm2koKyPEGL516M2Kwe8XgD/iyNgzadwb0dViH9fEWKN9J2q4boinnGP3QIWnJux8R72ry0wTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619844; c=relaxed/simple;
	bh=s1uK0dHt3KMykkfs4pFkoE7HWHk8Pvq1tcoRYidaz60=;
	h=Date:To:From:Subject:Message-Id; b=Urc16lGzmvOTv9y7wecu2GUfkqPGD0rI9OlDRQYoaQemtqzPyb9YB1GptXMJDNMVLJJPGlTRdVvn6W7lFwMtznqhWRMna92yPJLOADuWFnDLOv6YzCkBgDB2T9CohdLQK4yKytWTT5tmntYeaRpbd9wBI0BuTEkG5bk1tGXM72s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wzllJ7Uw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wzllJ7Uw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BF7C4CEDD;
	Sat, 22 Mar 2025 05:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619843;
	bh=s1uK0dHt3KMykkfs4pFkoE7HWHk8Pvq1tcoRYidaz60=;
	h=Date:To:From:Subject:From;
	b=wzllJ7UwB37e1zIZ4NU019fLm+CGrJWuc4+rXV/FRyIzchkPnh+tXwD04w6hpOo1P
	 awBZeX8Q3HVO+Z1vTLp1L5dr3dzGY1PbUF6A4Dt9LhqPjsyJLl6TQNpkt4ahmwnk8w
	 Btm8LOG5hLoM0A40PZTAVzPYOLx/ioYtka2slN3o=
Date: Fri, 21 Mar 2025 22:04:03 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,oleg@redhat.com,mhocko@suse.com,brauner@kernel.org,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fork-use-__vmalloc_node-for-stack-allocation.patch removed from -mm tree
Message-Id: <20250322050403.D0BF7C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: use __vmalloc_node() for stack allocation
has been removed from the -mm tree.  Its filename was
     fork-use-__vmalloc_node-for-stack-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: fork: use __vmalloc_node() for stack allocation
Date: Mon, 17 Mar 2025 17:36:14 +0100

Replace __vmalloc_node_range() by __vmalloc_node().  The last variant
requires less parameters and it uses exactly the same arguments which are
partly now hidden inside __vmalloc_node().

This change does not change any functionality.  It makes the code a bit
simpler.

Link: https://lkml.kernel.org/r/20250317163614.166502-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/fork.c~fork-use-__vmalloc_node-for-stack-allocation
+++ a/kernel/fork.c
@@ -311,11 +311,9 @@ static int alloc_thread_stack_node(struc
 	 * so memcg accounting is performed manually on assigning/releasing
 	 * stacks to tasks. Drop __GFP_ACCOUNT.
 	 */
-	stack = __vmalloc_node_range(THREAD_SIZE, THREAD_ALIGN,
-				     VMALLOC_START, VMALLOC_END,
+	stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN,
 				     THREADINFO_GFP & ~__GFP_ACCOUNT,
-				     PAGE_KERNEL,
-				     0, node, __builtin_return_address(0));
+				     node, __builtin_return_address(0));
 	if (!stack)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from urezki@gmail.com are


