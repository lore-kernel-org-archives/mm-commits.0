Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B208F20408A
	for <mm-commits@vger.kernel.org>; Wed, 12 Feb 2025 22:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739399745; cv=none; b=rpipWgXe1zgG6d85gjkVm2Sy1A0X3ka0TeQ7xAmEfx5+2HaMGYYE725YUQZrcoK0T4GkvIKZE8UrCYF1IwmZVrFqV4FL5RWsy6m2heVkw8IYsg0jvlcb5KouupOfwHEnEg+5WIgDrRFkiqH55uyEOZL9J5Bxu1x/W3Q69A6c8GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739399745; c=relaxed/simple;
	bh=mWLMdm4RoQcuIms2gdDES4Ldz8O7AZkeOIkzzDTd/pk=;
	h=Date:To:From:Subject:Message-Id; b=Rta4A9E3J0UcRbJhIMNm7oAWmiG+6LlsCersxLk/iWXlILTaE3gg09SYebg/ekcIhI4aOiOYdZCUw1yfj071dDlgTBPJRMktOjXH8lhG9xk2DOBCpDI2EHcrg0r1JqZdmTMwiXmWilDsmOSQJcIg7YJrfIeaml98qZNGE4mejok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u4E+6fu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u4E+6fu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB64C4CEDF;
	Wed, 12 Feb 2025 22:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739399745;
	bh=mWLMdm4RoQcuIms2gdDES4Ldz8O7AZkeOIkzzDTd/pk=;
	h=Date:To:From:Subject:From;
	b=u4E+6fu1kNXz9MqrFrThXrts8sg10DRzSVDFdO1JPB31VL3T31x/6judR79PQrUqs
	 7jUdToHTmE22PO4XizT5ubiHcBI8/bemVou5soW4MOulO+beygEQHr6plp8EAUUd4M
	 JgqmdW+ducgZcR2W/mrse4xk3R8BIvBqTru/sX+M=
Date: Wed, 12 Feb 2025 14:35:44 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,rostedt@goodmis.org,npache@redhat.com,glider@google.com,dvyukov@google.com,bigeasy@linutronix.de,andreyknvl@gmail.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-dont-call-find_vm_area-in-rt-kernel.patch added to mm-hotfixes-unstable branch
Message-Id: <20250212223545.2DB64C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: don't call find_vm_area() in RT kernel
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-dont-call-find_vm_area-in-rt-kernel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-dont-call-find_vm_area-in-rt-kernel.patch

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
From: Waiman Long <longman@redhat.com>
Subject: kasan: don't call find_vm_area() in RT kernel
Date: Wed, 12 Feb 2025 11:21:51 -0500

The following bug report appeared with a test run in a RT debug kernel.

[ 3359.353842] BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
[ 3359.353848] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 140605, name: kunit_try_catch
[ 3359.353853] preempt_count: 1, expected: 0
  :
[ 3359.353933] Call trace:
  :
[ 3359.353955]  rt_spin_lock+0x70/0x140
[ 3359.353959]  find_vmap_area+0x84/0x168
[ 3359.353963]  find_vm_area+0x1c/0x50
[ 3359.353966]  print_address_description.constprop.0+0x2a0/0x320
[ 3359.353972]  print_report+0x108/0x1f8
[ 3359.353976]  kasan_report+0x90/0xc8
[ 3359.353980]  __asan_load1+0x60/0x70

Commit e30a0361b851 ("kasan: make report_lock a raw spinlock") changes
report_lock to a raw_spinlock_t to avoid a similar RT problem.  The
print_address_description() function is called with report_lock acquired
and interrupt disabled.  However, the find_vm_area() function still needs
to acquire a spinlock_t which becomes a sleeping lock in the RT kernel. 
IOW, we can't call find_vm_area() in a RT kernel and changing report_lock
to a raw_spinlock_t is not enough to completely solve this RT kernel
problem.

Fix this bug report by skipping the find_vm_area() call in this case and
just print out the address as is.

For !RT kernel, follow the example set in commit 0cce06ba859a
("debugobjects,locking: Annotate debug_object_fill_pool() wait type
violation") and use DEFINE_WAIT_OVERRIDE_MAP() to avoid a spinlock_t
inside raw_spinlock_t warning.

Link: https://lkml.kernel.org/r/20250212162151.1599059-1-longman@redhat.com
Fixes: e30a0361b851 ("kasan: make report_lock a raw spinlock")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mariano Pache <npache@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   47 +++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

--- a/mm/kasan/report.c~kasan-dont-call-find_vm_area-in-rt-kernel
+++ a/mm/kasan/report.c
@@ -370,6 +370,38 @@ static inline bool init_task_stack_addr(
 			sizeof(init_thread_union.stack));
 }
 
+/*
+ * RT kernel cannot call find_vm_area() in atomic context. For !RT kernel,
+ * prevent spinlock_t inside raw_spinlock_t warning by raising wait-type
+ * to WAIT_SLEEP.
+ *
+ * Return: page pointer or NULL
+ */
+static inline struct page *kasan_print_vmalloc_info_ret_page(void *addr)
+{
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
+		static DEFINE_WAIT_OVERRIDE_MAP(vmalloc_map, LD_WAIT_SLEEP);
+		struct page *page = NULL;
+		struct vm_struct *va;
+
+		lock_map_acquire_try(&vmalloc_map);
+		va = find_vm_area(addr);
+		if (va) {
+			pr_err("The buggy address belongs to the virtual mapping at\n"
+			       " [%px, %px) created by:\n"
+			       " %pS\n",
+			       va->addr, va->addr + va->size, va->caller);
+			pr_err("\n");
+
+			page = vmalloc_to_page(addr);
+		}
+		lock_map_release(&vmalloc_map);
+		return page;
+	}
+	pr_err("The buggy address %px belongs to a vmalloc virtual mapping\n", addr);
+	return NULL;
+}
+
 static void print_address_description(void *addr, u8 tag,
 				      struct kasan_report_info *info)
 {
@@ -398,19 +430,8 @@ static void print_address_description(vo
 		pr_err("\n");
 	}
 
-	if (is_vmalloc_addr(addr)) {
-		struct vm_struct *va = find_vm_area(addr);
-
-		if (va) {
-			pr_err("The buggy address belongs to the virtual mapping at\n"
-			       " [%px, %px) created by:\n"
-			       " %pS\n",
-			       va->addr, va->addr + va->size, va->caller);
-			pr_err("\n");
-
-			page = vmalloc_to_page(addr);
-		}
-	}
+	if (is_vmalloc_addr(addr))
+		page = kasan_print_vmalloc_info_ret_page(addr);
 
 	if (page) {
 		pr_err("The buggy address belongs to the physical page:\n");
_

Patches currently in -mm which might be from longman@redhat.com are

kasan-dont-call-find_vm_area-in-rt-kernel.patch

