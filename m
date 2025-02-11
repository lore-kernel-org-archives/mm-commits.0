Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386C3272908;
	Tue, 11 Feb 2025 22:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739314672; cv=none; b=L9d44DiQePZVDo5SHz1i/E+KW7dZPQfoVx0meR11YInq6zaGST3Y59faqTQqfgHmOl+l1xcnLueihL1qk+eV5K85UCnKhQVlVgJrLFQG1CoMf82ZIrxDE52zPCNnepUIBY/ah/3uxo4mlHx9B4Gi5AV13BcBRcSJM0zjHPiTt+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739314672; c=relaxed/simple;
	bh=oUV6Ci2wrXg0RwC2lTlfl6pXAwiSc6nTNV8kazRpBVU=;
	h=Date:To:From:Subject:Message-Id; b=Ym7cASQQpdam478GHQgrKEJbTuAoRjJNLBglyoqBSpZI4Kj9pP9FnAaYO29nhXCYvy9phgHQzYh4OXZQSoct2a3N8TZfopCxYPqdDC6+sUjuLfo+gdFP9mIKnplSs/xizACEHpXK1SDlwgSqJEdGzAbeRp39tjR4p6fmy1xLamk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JC1O4tmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JC1O4tmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DDEC4CEDD;
	Tue, 11 Feb 2025 22:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739314671;
	bh=oUV6Ci2wrXg0RwC2lTlfl6pXAwiSc6nTNV8kazRpBVU=;
	h=Date:To:From:Subject:From;
	b=JC1O4tmS+SO1ttU91Lq5MyeQxDwAkFJs0B4VrRD8iBC47g4VWQlt8GigIwkWAHp33
	 390a/B4AYwy70R821BfExKe28nS/T4sFP3F8JzMJ4jtinE7PisJbW7hkyAPcT2gVBb
	 yyPQBppfTfK2AJ9oqVM3VNFr6lNRRRNkX7N28A18=
Date: Tue, 11 Feb 2025 14:57:50 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,rostedt@goodmis.org,npache@redhat.com,glider@google.com,dvyukov@google.com,bigeasy@linutronix.de,andreyknvl@gmail.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-dont-call-find_vm_area-in-rt-kernel.patch added to mm-hotfixes-unstable branch
Message-Id: <20250211225751.78DDEC4CEDD@smtp.kernel.org>
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
Date: Tue, 11 Feb 2025 11:07:50 -0500

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

print_address_description() is run with a raw_spinlock_t acquired and
interrupt disabled.  find_vm_area() needs to acquire a spinlock_t which
becomes a sleeping lock in the RT kernel.  IOW, we can't call
find_vm_area() in a RT kernel.  Fix this bug report by skipping the
find_vm_area() call in this case and just print out the address as is.

For !RT kernel, follow the example set in commit 0cce06ba859a
("debugobjects,locking: Annotate debug_object_fill_pool() wait type
violation") and use DEFINE_WAIT_OVERRIDE_MAP() to avoid a spinlock_t
inside raw_spinlock_t warning.

Link: https://lkml.kernel.org/r/20250211160750.1301353-1-longman@redhat.com
Fixes: c056a364e954 ("kasan: print virtual mapping info in reports")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mariano Pache <npache@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/kasan/report.c~kasan-dont-call-find_vm_area-in-rt-kernel
+++ a/mm/kasan/report.c
@@ -398,9 +398,20 @@ static void print_address_description(vo
 		pr_err("\n");
 	}
 
-	if (is_vmalloc_addr(addr)) {
-		struct vm_struct *va = find_vm_area(addr);
+	if (!is_vmalloc_addr(addr))
+		goto print_page;
 
+	/*
+	 * RT kernel cannot call find_vm_area() in atomic context.
+	 * For !RT kernel, prevent spinlock_t inside raw_spinlock_t warning
+	 * by raising wait-type to WAIT_SLEEP.
+	 */
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
+		static DEFINE_WAIT_OVERRIDE_MAP(vmalloc_map, LD_WAIT_SLEEP);
+		struct vm_struct *va;
+
+		lock_map_acquire_try(&vmalloc_map);
+		va = find_vm_area(addr);
 		if (va) {
 			pr_err("The buggy address belongs to the virtual mapping at\n"
 			       " [%px, %px) created by:\n"
@@ -410,8 +421,13 @@ static void print_address_description(vo
 
 			page = vmalloc_to_page(addr);
 		}
+		lock_map_release(&vmalloc_map);
+	} else {
+		pr_err("The buggy address %px belongs to a vmalloc virtual mapping\n",
+			addr);
 	}
 
+print_page:
 	if (page) {
 		pr_err("The buggy address belongs to the physical page:\n");
 		dump_page(page, "kasan: bad access detected");
_

Patches currently in -mm which might be from longman@redhat.com are

kasan-dont-call-find_vm_area-in-rt-kernel.patch

