Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FB31A2545
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 16:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230239; cv=none; b=ExVCDrmPNY9xmiXOI/NqMcPQQHSAgGhHmgtMrwpunSh9+49Fiygqpx9GPUuI93A20Det9UNhv1czoMjtSE4jRQUkFlD6psU6cEAlIV8bVzxeXt7qumtH92R+pKdpiENqw6Gja0kJZntnKy5Wmy6NhWSSZIrnV4Y2ffXjvepZqp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230239; c=relaxed/simple;
	bh=VLRR1DAa5X/153K/ew8mH6XUKGmEYaZFC01SuTgF/ic=;
	h=Date:To:From:Subject:Message-Id; b=Aam0AJETTldMuxAF76sSpGFV6JfiMjJA/3ed7ajfgD3nTgJdcNckzgPrHFi/RwGi4V6TmW8luAn8x10XPB7fPUExRX3CxQwtpN63mJVV25zqto1/1TRox7efREX9gFdQy6KkZi49JchuonT+JjTvS06zi8tOvmSvA6tl1Z/vb/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=THTuJ+U+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="THTuJ+U+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7A3C4CEE3;
	Mon, 17 Mar 2025 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742230239;
	bh=VLRR1DAa5X/153K/ew8mH6XUKGmEYaZFC01SuTgF/ic=;
	h=Date:To:From:Subject:From;
	b=THTuJ+U+JHBDBGwhiJqxG7Hu4LigLuCF4igq9i84v4bLhKyAgBBse+iB4JfDSfBO7
	 oPmnBRwXPh8J9Rn1OR7s71t20MSTe946UcAWZNrR//xfMY4c/dFxBgbtzvonAzdHVx
	 hR0WmeL/G40EUbwYGBTQtzhmqyE9O6lVdG4wLO6E=
Date: Mon, 17 Mar 2025 09:50:38 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,oleg@redhat.com,brauner@kernel.org,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-use-__vmalloc_node-for-stack-allocation.patch added to mm-unstable branch
Message-Id: <20250317165039.4F7A3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: use __vmalloc_node() for stack allocation
has been added to the -mm mm-unstable branch.  Its filename is
     fork-use-__vmalloc_node-for-stack-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-use-__vmalloc_node-for-stack-allocation.patch

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

fork-use-__vmalloc_node-for-stack-allocation.patch

