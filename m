Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360A413D260
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292059; cv=none; b=t1ZfxG4jCwr3wqmS/wzZWc3NJW+/3IoyxWOM3+Gvv3GL6IQzm0Z7Pv0nhb4jRgE6zQcOgRTpFecl08lpMf3HGjajtn8nydMXLq7bjxXDtSpgaO8CtoHgBp9C+hnvLtBbbluV1LFPH2BEwb4ts6F7lfi53+KTEmfNliR7ysd5tbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292059; c=relaxed/simple;
	bh=hvFQhCeUL6MqBnFB1z4YTaNhTrK5apD0bwv1A05j4iw=;
	h=Date:To:From:Subject:Message-Id; b=gjE7aGDv1P5/uWo9XuCOtd1rRAxYekawu+6h6VobHuAeLiE/8mRU+hF48yHbiPBHIAUkKbESfzs0HRi08NZnbzMrjKSDi3eJQ3jPIZoxcRoqhGOFlNelkqcr6u3IaDfpD8t8Jm4/OMg5ydJyHanCLlMLheSancQ2c/1BdPogZeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ecyvlhPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ecyvlhPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDCAC2BD10;
	Sat,  6 Jul 2024 18:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292059;
	bh=hvFQhCeUL6MqBnFB1z4YTaNhTrK5apD0bwv1A05j4iw=;
	h=Date:To:From:Subject:From;
	b=ecyvlhPYVLMeiyvnza95dhTgcT97q0Bl9/0BIuQD4ihOy9iIPPP92DFYPaAEgBnO2
	 NQTrx1dgeYuxx1JWmoJv/++MjGun8Eemi9DFLtOSwmtoP6SPGsz/S41YcDGRDUu2W+
	 6ipZfo8BLlnUGDNaVRrTq200Lz6qmRnW7EAc9+5g=
Date: Sat, 06 Jul 2024 11:54:18 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,oleg@redhat.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch removed from -mm tree
Message-Id: <20240706185419.0BDCAC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/fork.c: put set_max_threads()/task_struct_whitelist() in __init section
has been removed from the -mm tree.  Its filename was
     kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: kernel/fork.c: put set_max_threads()/task_struct_whitelist() in __init section
Date: Mon, 1 Jul 2024 01:34:10 +0000

The functions set_max_threads() and task_struct_whitelist() are only used
by fork_init() during bootup.

Let's add __init tag to them.

Link: https://lkml.kernel.org/r/20240701013410.17260-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/fork.c~kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section
+++ a/kernel/fork.c
@@ -997,7 +997,7 @@ void __init __weak arch_task_cache_init(
 /*
  * set_max_threads
  */
-static void set_max_threads(unsigned int max_threads_suggested)
+static void __init set_max_threads(unsigned int max_threads_suggested)
 {
 	u64 threads;
 	unsigned long nr_pages = PHYS_PFN(memblock_phys_mem_size() - memblock_reserved_size());
@@ -1023,7 +1023,7 @@ static void set_max_threads(unsigned int
 int arch_task_struct_size __read_mostly;
 #endif
 
-static void task_struct_whitelist(unsigned long *offset, unsigned long *size)
+static void __init task_struct_whitelist(unsigned long *offset, unsigned long *size)
 {
 	/* Fetch thread_struct whitelist for the architecture. */
 	arch_thread_struct_whitelist(offset, size);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch
mm-use-zonelist_zone-to-get-zone.patch

