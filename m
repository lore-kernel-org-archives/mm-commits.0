Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8087B353368
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 22:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755643672; cv=none; b=tsEueZZcxXqurCuVSXScjpLRnZZ5I6Bg7D/XZkN+OcpoUwXvnR0T7f6/AZAYmW6c/7H9knEkxk3fpQe14pUpKP3PE1uEWgr+SnaS4zifnBPP+yUjBqMN6EJ+LOId4VGl8Iubsxlc02FolOHRBhLd1B4bt7g0T9Z7LPvDHjdXdvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755643672; c=relaxed/simple;
	bh=S8FuhvlGFSb42wdixcjGBflqwvD9PIIIRWKz9uBPLVg=;
	h=Date:To:From:Subject:Message-Id; b=fJZdj6Eu4vonmyIl+VD4cw1kBZHN4Nq1hfj0z0hMreP6Coi3Uq8FSCkN23Zz+5eLFiPFgvkuu1zLvfh0X8ILa/OnHw8gCUSXaxAk8XqmcL7XLEQSlSCrHJZYYfk97V2obaZYjSc96tNVlyFWbO0Sog1OSKpW2vn1ubZy2x/+3OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OR4uPHOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OR4uPHOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5C4C4CEF1;
	Tue, 19 Aug 2025 22:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755643671;
	bh=S8FuhvlGFSb42wdixcjGBflqwvD9PIIIRWKz9uBPLVg=;
	h=Date:To:From:Subject:From;
	b=OR4uPHOzoEI3+CxusP43JCarnMyyTh+RbAu8LpiIcKZqcDgUd67xFxMmMXl0IJEN8
	 5kSu+mMKvc7xtTpkI3m1EfzgjdID/ACQA/56sRxbVd86LKQF3Zb8Ya+pTCI8P8AObN
	 vNCpyjlRj748bDABWLRTCjWvyLETeZ4BXzuiIrcc=
Date: Tue, 19 Aug 2025 15:47:51 -0700
To: mm-commits@vger.kernel.org,lujialin4@huawei.com,leitao@debian.org,john.ogness@linutronix.de,gregkh@linuxfoundation.org,catalin.marinas@arm.com,gubowen5@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-possible-deadlock-in-kmemleak.patch added to mm-hotfixes-unstable branch
Message-Id: <20250819224751.DB5C4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix possible deadlock in kmemleak
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-possible-deadlock-in-kmemleak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-possible-deadlock-in-kmemleak.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Gu Bowen <gubowen5@huawei.com>
Subject: mm: fix possible deadlock in kmemleak
Date: Mon, 18 Aug 2025 17:09:44 +0800

Our syztester report the lockdep WARNING [1], which was identified in
stable kernel version 5.10.  However, this deadlock path no longer exists
due to the refactoring of console_lock in v6.2-rc1 [2].  Coincidentally,
there are two types of deadlocks that we have found here.  One is the ABBA
deadlock, as mentioned above [1], and the other is the AA deadlock was
reported by Breno [3].  The latter's deadlock issue persists.

To solve this problem, switch to printk_safe mode before printing warning
message, this will redirect all printk()-s to a special per-CPU buffer,
which will be flushed later from a safe context (irq work), and this
deadlock problem can be avoided. The proper API to use should be
printk_deferred_enter()/printk_deferred_exit() [4].

[1]
https://lore.kernel.org/all/20250730094914.566582-1-gubowen5@huawei.com/
[2]
https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/
[3]
https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t
[4]
https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/
====================

Link: https://lkml.kernel.org/r/20250818090945.1003644-1-gubowen5@huawei.com
Signed-off-by: Gu Bowen <gubowen5@huawei.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Lu Jialin <lujialin4@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/mm/kmemleak.c~mm-fix-possible-deadlock-in-kmemleak
+++ a/mm/kmemleak.c
@@ -437,9 +437,15 @@ static struct kmemleak_object *__lookup_
 		else if (untagged_objp == untagged_ptr || alias)
 			return object;
 		else {
+			/*
+			 * Printk deferring due to the kmemleak_lock held.
+			 * This is done to avoid deadlock.
+			 */
+			printk_deferred_enter();
 			kmemleak_warn("Found object by alias at 0x%08lx\n",
 				      ptr);
 			dump_object_info(object);
+			printk_deferred_exit();
 			break;
 		}
 	}
@@ -736,6 +742,11 @@ static int __link_object(struct kmemleak
 		else if (untagged_objp + parent->size <= untagged_ptr)
 			link = &parent->rb_node.rb_right;
 		else {
+			/*
+			 * Printk deferring due to the kmemleak_lock held.
+			 * This is done to avoid deadlock.
+			 */
+			printk_deferred_enter();
 			kmemleak_stop("Cannot insert 0x%lx into the object search tree (overlaps existing)\n",
 				      ptr);
 			/*
@@ -743,6 +754,7 @@ static int __link_object(struct kmemleak
 			 * be freed while the kmemleak_lock is held.
 			 */
 			dump_object_info(parent);
+			printk_deferred_exit();
 			return -EEXIST;
 		}
 	}
@@ -858,8 +870,14 @@ static void delete_object_part(unsigned
 	object = __find_and_remove_object(ptr, 1, objflags);
 	if (!object) {
 #ifdef DEBUG
+		/*
+		 * Printk deferring due to the kmemleak_lock held.
+		 * This is done to avoid deadlock.
+		 */
+		printk_deferred_enter();
 		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
 			      ptr, size);
+		printk_deferred_exit();
 #endif
 		goto unlock;
 	}
_

Patches currently in -mm which might be from gubowen5@huawei.com are

mm-fix-possible-deadlock-in-kmemleak.patch

