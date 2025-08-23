Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F493234;
	Sat, 23 Aug 2025 00:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755910116; cv=none; b=cfczzZIcphTWUsI7eybopa261gUAfZcZ0ypty0hi0QdE9J++n/6JyH9lcePrhkA0LQz56Wcs+TXQP8X5xS1Gp4luVuH9B7yl2lxuXTabhcRcq+aRxp69KA1Mt59GZOwPr74vbBairOEyqCVUTasLYxBa7wXEgdJpyIu9zt+cAUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755910116; c=relaxed/simple;
	bh=zrqluCsZft0A80ykme0GAbiSiNy7CX/v0bduFveBWuE=;
	h=Date:To:From:Subject:Message-Id; b=IJfN3/QZxjx9aVQii+fWmY3zMETN0ooZjZZxAv7w5igBCTDUi+RVLUKzS/6oaRfCIYfWaCCnmQG35u4Bm2QZBnAw5mwf7eUVnsRMtFOUlO/joyrghoyiRLGx2zw66P+sPNmMrDELJr1YG64JS6jo+7tfor0sKZyiJ7jCLZG4F2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UZLCT4GO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UZLCT4GO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3E7C4CEED;
	Sat, 23 Aug 2025 00:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755910114;
	bh=zrqluCsZft0A80ykme0GAbiSiNy7CX/v0bduFveBWuE=;
	h=Date:To:From:Subject:From;
	b=UZLCT4GO7nwp6z1xjcjm2tupMSh9MjMoTEm7QutlDAXohnfOoUv6a4rgYcWYjnDIX
	 3DHej53bt2cQRIZKKqrWt8dX+IdQQ7rw62krESm0nZ9EgbWSfedNHIPSued96gnnWF
	 le7zOrOPLV0ShLsg7X192Tt1L/HkxNo9wiWt+NqI=
Date: Fri, 22 Aug 2025 17:48:33 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,lujialin4@huawei.com,leitao@debian.org,john.ogness@linutronix.de,gregkh@linuxfoundation.org,catalin.marinas@arm.com,gubowen5@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-possible-deadlock-in-kmemleak.patch added to mm-hotfixes-unstable branch
Message-Id: <20250823004833.EB3E7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: gix possible deadlock in kmemleak
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
Subject: mm: gix possible deadlock in kmemleak
Date: Fri, 22 Aug 2025 15:35:41 +0800

There are some AA deadlock issues in kmemleak, similar to the situation
reported by Breno [1].  The deadlock path is as follows:

mem_pool_alloc()
  -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
      -> pr_warn()
          -> netconsole subsystem
	     -> netpoll
	         -> __alloc_skb
		   -> __create_object
		     -> raw_spin_lock_irqsave(&kmemleak_lock, flags);

To solve this problem, switch to printk_safe mode before printing warning
message, this will redirect all printk()-s to a special per-CPU buffer,
which will be flushed later from a safe context (irq work), and this
deadlock problem can be avoided.  The proper API to use should be
printk_deferred_enter()/printk_deferred_exit() [2].  Another way is to
place the warn print after kmemleak is released.

Link: https://lkml.kernel.org/r/20250822073541.1886469-1-gubowen5@huawei.com
Link: https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t [1]
Link: https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/ [2]
Signed-off-by: Gu Bowen <gubowen5@huawei.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Lu Jialin <lujialin4@huawei.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

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
@@ -856,13 +868,8 @@ static void delete_object_part(unsigned
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
 	object = __find_and_remove_object(ptr, 1, objflags);
-	if (!object) {
-#ifdef DEBUG
-		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
-			      ptr, size);
-#endif
+	if (!object)
 		goto unlock;
-	}
 
 	/*
 	 * Create one or two objects that may result from the memory block
@@ -882,8 +889,14 @@ static void delete_object_part(unsigned
 
 unlock:
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
-	if (object)
+	if (object) {
 		__delete_object(object);
+	} else {
+#ifdef DEBUG
+		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
+			      ptr, size);
+#endif
+	}
 
 out:
 	if (object_l)
_

Patches currently in -mm which might be from gubowen5@huawei.com are

mm-fix-possible-deadlock-in-kmemleak.patch

