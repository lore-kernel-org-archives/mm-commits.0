From: akpm@linux-foundation.org
Subject: [merged] remove-__get_cpu_var-and-__raw_get_cpu_var-macros.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:10:35 -0800
Message-ID: <548d0dbb.vZ9C7N9DghI4SNV5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaLNEK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:10:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: remove __get_cpu_var and __raw_get_cpu_var macros
has been removed from the -mm tree.  Its filename was
     remove-__get_cpu_var-and-__raw_get_cpu_var-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: percpu: remove __get_cpu_var and __raw_get_cpu_var macros

No user is left in the kernel source tree.  Therefore we can drop the
definitions.

This is the final merge of the transition away from __get_cpu_var.  After
this patch the kernel will not build if anyone uses __get_cpu_var.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/percpu-defs.h~remove-__get_cpu_var-and-__raw_get_cpu_var-macros include/linux/percpu-defs.h
--- a/include/linux/percpu-defs.h~remove-__get_cpu_var-and-__raw_get_cpu_var-macros
+++ a/include/linux/percpu-defs.h
@@ -254,8 +254,6 @@ do {									\
 #endif	/* CONFIG_SMP */
 
 #define per_cpu(var, cpu)	(*per_cpu_ptr(&(var), cpu))
-#define __raw_get_cpu_var(var)	(*raw_cpu_ptr(&(var)))
-#define __get_cpu_var(var)	(*this_cpu_ptr(&(var)))
 
 /*
  * Must be an lvalue. Since @var must be a simple identifier,
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch
linux-next.patch

