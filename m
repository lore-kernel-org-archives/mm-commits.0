Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAA42153E0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188251; cv=none; b=tqeeWBVz2p+iQBe5nR/Ltn3y4RKucbzhUC+xO+9VA5EkZ/JhjCxhAcuVDD/w5PkAPgX87PoDMQd1STZiHfZwQZPdL8YwibhAKCCW9FVPsF7lXR8iPaISnr3aTPWVZf6Df+L3rUKtAqqbShveOG4hFId+cr150W7sNQ0iGhqgz8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188251; c=relaxed/simple;
	bh=6wXkXYRIZ8vRrGbUQpTPP/tlYfMHD5n6ybaO3V40efk=;
	h=Date:To:From:Subject:Message-Id; b=EfT0yY3/FN9RucExijyHXD7LT74QmOSO/RyznJVISxwOiL2cbLAWO7BK0IoqKRusrghV2ngezFC+MqRd6jP0DJ0doAiXZBX2oML4BIs0vOIJEPc7w2zP4ebX3bivtvoMIkZ97ZQ0lskEEieaUePHsCB0w6itXsk2AyDJp0lrwYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YDQkonPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YDQkonPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129B5C4CEEC;
	Mon, 17 Mar 2025 05:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188251;
	bh=6wXkXYRIZ8vRrGbUQpTPP/tlYfMHD5n6ybaO3V40efk=;
	h=Date:To:From:Subject:From;
	b=YDQkonPM66nTzEKlP4LyyHyDiQEJbt3Aheh39ydYqZCUFPjUOIn2vx+1UtZF8nmOq
	 CJcwnPmO0ktSKJdzgWlx6y2K6q6iIkFpPf9Rk/W1Nenm9MDdFF77o+MwkoiRfgFZQ7
	 WtRWvPpCw8JiFlwnbK/B6Rm4XKx7/e0vgd3/BbmM=
Date: Sun, 16 Mar 2025 22:10:50 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-add-support-for-dumping-physical-and-__percpu-object-info.patch removed from -mm tree
Message-Id: <20250317051051.129B5C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: add support for dumping physical and __percpu object info
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-add-support-for-dumping-physical-and-__percpu-object-info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: add support for dumping physical and __percpu object info
Date: Thu, 6 Feb 2025 11:45:36 +0000

Patch series "mm: kmemleak: Usability improvements".

Following a recent false positive tracking that led to commit 488b5b9eca68
("mm: kmemleak: fix upper boundary check for physical address objects"), I
needed kmemleak to give me more debug information about the objects it is
tracking.  This lead to the first patch of this series.  The second patch
changes the kmemleak-test module to show the raw pointers for debugging
purposes.


This patch (of 2):

Currently, echo dump=...  > /sys/kernel/debug/kmemleak only looks up the
main virtual address object tree.  However, for debugging, it's useful to
dump information about physical address and __percpu objects.

Search all three object trees for the dump= command and also print the
type of the object if not virtual: "(phys)" or "(percpu)".  In addition,
allow search by alias (pointer within the object).

Link: https://lkml.kernel.org/r/20250206114537.2597764-1-catalin.marinas@arm.com
Link: https://lkml.kernel.org/r/20250206114537.2597764-2-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   52 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 13 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-add-support-for-dumping-physical-and-__percpu-object-info
+++ a/mm/kmemleak.c
@@ -352,6 +352,15 @@ static bool unreferenced_object(struct k
 			       jiffies_last_scan);
 }
 
+static const char *__object_type_str(struct kmemleak_object *object)
+{
+	if (object->flags & OBJECT_PHYS)
+		return " (phys)";
+	if (object->flags & OBJECT_PERCPU)
+		return " (percpu)";
+	return "";
+}
+
 /*
  * Printing of the unreferenced objects information to the seq file. The
  * print_unreferenced function must be called with the object->lock held.
@@ -364,8 +373,9 @@ static void print_unreferenced(struct se
 	unsigned int nr_entries;
 
 	nr_entries = stack_depot_fetch(object->trace_handle, &entries);
-	warn_or_seq_printf(seq, "unreferenced object 0x%08lx (size %zu):\n",
-			  object->pointer, object->size);
+	warn_or_seq_printf(seq, "unreferenced object%s 0x%08lx (size %zu):\n",
+			   __object_type_str(object),
+			   object->pointer, object->size);
 	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
 			   object->comm, object->pid, object->jiffies);
 	hex_dump_object(seq, object);
@@ -384,10 +394,10 @@ static void print_unreferenced(struct se
  */
 static void dump_object_info(struct kmemleak_object *object)
 {
-	pr_notice("Object 0x%08lx (size %zu):\n",
-			object->pointer, object->size);
+	pr_notice("Object%s 0x%08lx (size %zu):\n",
+		  __object_type_str(object), object->pointer, object->size);
 	pr_notice("  comm \"%s\", pid %d, jiffies %lu\n",
-			object->comm, object->pid, object->jiffies);
+		  object->comm, object->pid, object->jiffies);
 	pr_notice("  min_count = %d\n", object->min_count);
 	pr_notice("  count = %d\n", object->count);
 	pr_notice("  flags = 0x%x\n", object->flags);
@@ -1998,25 +2008,41 @@ static int kmemleak_open(struct inode *i
 	return seq_open(file, &kmemleak_seq_ops);
 }
 
-static int dump_str_object_info(const char *str)
+static bool __dump_str_object_info(unsigned long addr, unsigned int objflags)
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
+
+	object = __find_and_get_object(addr, 1, objflags);
+	if (!object)
+		return false;
+
+	raw_spin_lock_irqsave(&object->lock, flags);
+	dump_object_info(object);
+	raw_spin_unlock_irqrestore(&object->lock, flags);
+
+	put_object(object);
+
+	return true;
+}
+
+static int dump_str_object_info(const char *str)
+{
 	unsigned long addr;
+	bool found = false;
 
 	if (kstrtoul(str, 0, &addr))
 		return -EINVAL;
-	object = find_and_get_object(addr, 0);
-	if (!object) {
+
+	found |= __dump_str_object_info(addr, 0);
+	found |= __dump_str_object_info(addr, OBJECT_PHYS);
+	found |= __dump_str_object_info(addr, OBJECT_PERCPU);
+
+	if (!found) {
 		pr_info("Unknown object at 0x%08lx\n", addr);
 		return -EINVAL;
 	}
 
-	raw_spin_lock_irqsave(&object->lock, flags);
-	dump_object_info(object);
-	raw_spin_unlock_irqrestore(&object->lock, flags);
-
-	put_object(object);
 	return 0;
 }
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


