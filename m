Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8569317E4
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738889142; cv=none; b=CJkJNHzDOjYDFRzX2T48Zc4VPVTDG2kOinAvmYGfqTRn0XjoPvJnJmtnZs3kzzpUZPuFll8k2upRrBin+fWL0STzd6elgmo3jozlzU/D64AUbNiMCEnI3Hrnm3Dw8gv2gDIy3kV0Vffb7bqGnjIyvguVTAyxUU3o5ENHgx+hNsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738889142; c=relaxed/simple;
	bh=D5o7R9PB+mQwF3Ob0vpW2R8P5fredq/09wkD3anl7FE=;
	h=Date:To:From:Subject:Message-Id; b=iPwee6Qnw3cLpluSguHC/O+fgP/7XlQMVc5s75Cf5/wpIk6g9R5GDWpXNaVSJa1BQJDAL+/Zbr3wJlUoxSAMwqRAkNCw/dAIzMzAfobsNDZBoezzTnfoKuU8rEU2oFu9VDzPA3bYpNgrosr9hqegcgngf7uEpyg++2QbndmSFs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=girqQeYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="girqQeYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD573C4CEDD;
	Fri,  7 Feb 2025 00:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738889141;
	bh=D5o7R9PB+mQwF3Ob0vpW2R8P5fredq/09wkD3anl7FE=;
	h=Date:To:From:Subject:From;
	b=girqQeYDCFqIrBvaznezh9g8Clh33+ZnZ+zQcAz6G+nPeD7xLeaxSxodhu7wLVp3V
	 1d7XbJHg1A+cppBfr6k00G673WCgv0O1ab1EgIai2eU+6yFYtELGWh3zo5B0ESYuP2
	 GOYAVT9R06y0t+0K1pjejrTQVSSoRy/h+2JfXFIg=
Date: Thu, 06 Feb 2025 16:45:40 -0800
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-add-support-for-dumping-physical-and-__percpu-object-info.patch added to mm-unstable branch
Message-Id: <20250207004540.DD573C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: add support for dumping physical and __percpu object info
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-add-support-for-dumping-physical-and-__percpu-object-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-add-support-for-dumping-physical-and-__percpu-object-info.patch

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

mm-kmemleak-add-support-for-dumping-physical-and-__percpu-object-info.patch
samples-kmemleak-print-the-raw-pointers-for-debugging-purposes.patch

