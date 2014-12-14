From: akpm@linux-foundation.org
Subject: [merged] update-local_opstxt-to-reflect-this_cpu-operations.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:10:38 -0800
Message-ID: <548d0dbe.yDeDGOHy1LlEWmFo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbaLNEKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:10:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: update local_ops.txt to reflect this_cpu operations
has been removed from the -mm tree.  Its filename was
     update-local_opstxt-to-reflect-this_cpu-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: percpu: update local_ops.txt to reflect this_cpu operations

Update the documentation to reflect changes due to the availability of
this_cpu operations.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/local_ops.txt |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN Documentation/local_ops.txt~update-local_opstxt-to-reflect-this_cpu-operations Documentation/local_ops.txt
--- a/Documentation/local_ops.txt~update-local_opstxt-to-reflect-this_cpu-operations
+++ a/Documentation/local_ops.txt
@@ -8,6 +8,11 @@ to implement them for any given architec
 properly. It also stresses on the precautions that must be taken when reading
 those local variables across CPUs when the order of memory writes matters.
 
+Note that local_t based operations are not recommended for general kernel use.
+Please use the this_cpu operations instead unless there is really a special purpose.
+Most uses of local_t in the kernel have been replaced by this_cpu operations.
+this_cpu operations combine the relocation with the local_t like semantics in
+a single instruction and yield more compact and faster executing code.
 
 
 * Purpose of local atomic operations
@@ -87,10 +92,10 @@ the per cpu variable. For instance :
 	local_inc(&get_cpu_var(counters));
 	put_cpu_var(counters);
 
-If you are already in a preemption-safe context, you can directly use
-__get_cpu_var() instead.
+If you are already in a preemption-safe context, you can use
+this_cpu_ptr() instead.
 
-	local_inc(&__get_cpu_var(counters));
+	local_inc(this_cpu_ptr(&counters));
 
 
 
@@ -134,7 +139,7 @@ static void test_each(void *info)
 {
 	/* Increment the counter from a non preemptible context */
 	printk("Increment on cpu %d\n", smp_processor_id());
-	local_inc(&__get_cpu_var(counters));
+	local_inc(this_cpu_ptr(&counters));
 
 	/* This is what incrementing the variable would look like within a
 	 * preemptible context (it disables preemption) :
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch
linux-next.patch

