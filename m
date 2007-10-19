From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-samples-remove-asm.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:36:45 -0700
Message-ID: <200710190436.l9J4ajwe015413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbXJSEg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers - Remove Unneeded asm
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-samples-remove-asm.patch

This patch was dropped because it was folded into linux-kernel-markers-samples.patch

------------------------------------------------------
Subject: Linux Kernel Markers - Remove Unneeded asm
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

On s390 (with some compiler) :

> samples/markers/marker-example.c: In function 'my_open':
> samples/markers/marker-example.c:22: warning: asm operand 0 probably doesn't
> match constraints
> samples/markers/marker-example.c:24: warning: asm operand 0 probably doesn't
> match constraints
> samples/markers/marker-example.c:22: error: impossible constraint in 'asm'
> samples/markers/marker-example.c:24: error: impossible constraint in 'asm'

It is there to specify that the __mark_##name variable is used. In the
first implementations, I did not pass it as a parameter to the following
function call, so I had to find a way to tell gcc that it should not go
away. I first planned to use a "__used" attribute, but Jeremy said it
was buggy on some gcc versions. (http://lkml.org/lkml/2006/10/17/235)

He suggested the following:
  asm volatile("" : : "m" (thing));

But I guess it ended up not working so well, since I changed it for a
"i" operand. However, if some s390 gccs do not like it, it's better to
figure out another solution.

Well, as a very very simple solution, let's just remove the asm. It is
not needed anymore since the pointer is passed as parameter to the
called function.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/marker.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/marker.h~linux-kernel-markers-samples-remove-asm include/linux/marker.h
--- a/include/linux/marker.h~linux-kernel-markers-samples-remove-asm
+++ a/include/linux/marker.h
@@ -61,7 +61,6 @@ struct marker {
 		__attribute__((section("__markers"), aligned(8))) =	\
 		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
 		0, __mark_empty_function, NULL };			\
-		asm volatile("" : : "i" (&__mark_##name));		\
 		__mark_check_format(format, ## args);			\
 		if (unlikely(__mark_##name.state)) {			\
 			preempt_disable();				\
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
change-struct-marker-users.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
linux-kernel-markers.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-remove-asm.patch
linux-kernel-markers-documentation.patch
