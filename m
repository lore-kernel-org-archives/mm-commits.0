Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290FCBE47
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628250; cv=none; b=a2BsVvjrNXE9M6hk3DG0XBmx2+0dd69mmGqgaoEKEQ2ED4UshrZGXYiaknviz1gUJBHoXsKzxqDQNHS+Sany/imM5JQl94IkZAIUGJG29/CBGESlED0PP8KDRW7C1JBOytYwEGzerKTRPNCYaPo1I+PgAEjdp/dwOU0wHYEerZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628250; c=relaxed/simple;
	bh=bXxCNieSVQDGwHvSm+d7EOfMmtchkAfP+BX9EGtyRnM=;
	h=Date:To:From:Subject:Message-Id; b=VKLHne8LJuBo4A0Kct2tD7l0KFWhU4lvU7SuiGM7Kq45gB1E5NEgt7PNrlvQYsJytcl3yDPoXvUqUwhAY1n+4MgG8gEiojw2E4cu02KYd6GqnsUxhTQ9GQeAROzko1OF/kCoq//1l/ErbacmvStYxcIjliAYpH4uQs4NefTaq3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bi0l3oY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bi0l3oY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F049BC116B1;
	Sat, 29 Jun 2024 02:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628250;
	bh=bXxCNieSVQDGwHvSm+d7EOfMmtchkAfP+BX9EGtyRnM=;
	h=Date:To:From:Subject:From;
	b=Bi0l3oY3P4YXwA8XY0YyIUDO82GvxtP5E2VE5d5DCA8UitQgcCBlyKT3A8PYa8djH
	 no8P1emTdbWoFkWJjIddnLBGOzKOG6FoBENovtpbl8JZrFLenxOwgUxJqEFmbhuwzi
	 7nQLAKWyUO7jA+0NBFtnzc2z4T0f++idi0BeWQUU=
Date: Fri, 28 Jun 2024 19:30:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-introduce-memset_no_sanitize_memory.patch removed from -mm tree
Message-Id: <20240629023049.F049BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: introduce memset_no_sanitize_memory()
has been removed from the -mm tree.  Its filename was
     kmsan-introduce-memset_no_sanitize_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: introduce memset_no_sanitize_memory()
Date: Fri, 21 Jun 2024 13:34:56 +0200

Add a wrapper for memset() that prevents unpoisoning.  This is useful for
filling memory allocator redzones.

Link: https://lkml.kernel.org/r/20240621113706.315500-13-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmsan.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/linux/kmsan.h~kmsan-introduce-memset_no_sanitize_memory
+++ a/include/linux/kmsan.h
@@ -255,6 +255,19 @@ void kmsan_enable_current(void);
  */
 void kmsan_disable_current(void);
 
+/**
+ * memset_no_sanitize_memory(): Fill memory without KMSAN instrumentation.
+ * @s: address of kernel memory to fill.
+ * @c: constant byte to fill the memory with.
+ * @n: number of bytes to fill.
+ *
+ * This is like memset(), but without KMSAN instrumentation.
+ */
+static inline void *memset_no_sanitize_memory(void *s, int c, size_t n)
+{
+	return __memset(s, c, n);
+}
+
 #else
 
 static inline void kmsan_init_shadow(void)
@@ -362,6 +375,11 @@ static inline void kmsan_disable_current
 {
 }
 
+static inline void *memset_no_sanitize_memory(void *s, int c, size_t n)
+{
+	return memset(s, c, n);
+}
+
 #endif
 
 #endif /* _LINUX_KMSAN_H */
_

Patches currently in -mm which might be from iii@linux.ibm.com are


