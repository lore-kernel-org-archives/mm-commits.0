Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9AB14B96E;
	Wed, 12 Nov 2025 00:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908568; cv=none; b=mh8dH5+6tfI+MExAMlBNNkFu4uBnVO47+Jaw7Fa7nsi0jn8yzOSjbHIUZCX/KwpIFnBfmuNvoyOLd3tY8+uD8JadVHH2hjaLgiyxHHZ2DReGuLhWZN8al76LkPO4XI0Zc2i9ETx6vXpZO1UXeU846xGkp8uPi5McOLAJ+ub4Gqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908568; c=relaxed/simple;
	bh=ud67ClL1cJB/RoFjxkVzTDbs1WLtyc2vQme39uuKjPE=;
	h=Date:To:From:Subject:Message-Id; b=UezBvGE+/6CUUqvARz9glJINkLx7POZqoXmY4StSVW4OIAR8KI4deDucL07zuTSem3GuKcgKhc4adH4ugYM0yzjLmIj/RFiyziFjhD4pxeHkGpbHqnZDq63HdERzR9567rfOnpaWt2TEn0LtybFWV09XRlMwJ8g6C9R2eXpluqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2DF541Km; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2DF541Km"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7A9C113D0;
	Wed, 12 Nov 2025 00:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908568;
	bh=ud67ClL1cJB/RoFjxkVzTDbs1WLtyc2vQme39uuKjPE=;
	h=Date:To:From:Subject:From;
	b=2DF541Km4mFMx2DlW+2wLNY8E1uzN4HpPh6fvn1u48a6q3Bo6ecgf6CFS5IgBaCAo
	 QLbyrKqfioidPcCYvQNYgNlb7vb37WFFvhDNyiONaTtY+p80d7jUKEUtKQeGyq5tR5
	 nuhRAgHPLJA0bqqEjqwmSLHwPSCye4BMOgwI2t7I=
Date: Tue, 11 Nov 2025 16:49:27 -0800
To: mm-commits@vger.kernel.org,yee.lee@mediatek.com,xiejiyuan@vivo.com,will@kernel.org,stable@vger.kernel.org,samitolvanen@google.com,keescook@chromium.org,elver@google.com,andreyknvl@gmail.com,zhichi.lin@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scs-fix-a-wrong-parameter-in-__scs_magic.patch removed from -mm tree
Message-Id: <20251112004928.4C7A9C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scs: fix a wrong parameter in __scs_magic
has been removed from the -mm tree.  Its filename was
     scs-fix-a-wrong-parameter-in-__scs_magic.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhichi Lin <zhichi.lin@vivo.com>
Subject: scs: fix a wrong parameter in __scs_magic
Date: Sat, 11 Oct 2025 16:22:22 +0800

__scs_magic() needs a 'void *' variable, but a 'struct task_struct *' is
given.  'task_scs(tsk)' is the starting address of the task's shadow call
stack, and '__scs_magic(task_scs(tsk))' is the end address of the task's
shadow call stack.  Here should be '__scs_magic(task_scs(tsk))'.

The user-visible effect of this bug is that when CONFIG_DEBUG_STACK_USAGE
is enabled, the shadow call stack usage checking function
(scs_check_usage) would scan an incorrect memory range.  This could lead
to:

1. **Inaccurate stack usage reporting**: The function would calculate
   wrong usage statistics for the shadow call stack, potentially showing
   incorrect value in kmsg.

2. **Potential kernel crash**: If the value of __scs_magic(tsk)is
   greater than that of __scs_magic(task_scs(tsk)), the for loop may
   access unmapped memory, potentially causing a kernel panic.  However,
   this scenario is unlikely because task_struct is allocated via the slab
   allocator (which typically returns lower addresses), while the shadow
   call stack returned by task_scs(tsk) is allocated via vmalloc(which
   typically returns higher addresses).

However, since this is purely a debugging feature
(CONFIG_DEBUG_STACK_USAGE), normal production systems should be not
unaffected.  The bug only impacts developers and testers who are actively
debugging stack usage with this configuration enabled.

Link: https://lkml.kernel.org/r/20251011082222.12965-1-zhichi.lin@vivo.com
Fixes: 5bbaf9d1fcb9 ("scs: Add support for stack usage debugging")
Signed-off-by: Jiyuan Xie <xiejiyuan@vivo.com>
Signed-off-by: Zhichi Lin <zhichi.lin@vivo.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yee Lee <yee.lee@mediatek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/scs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/scs.c~scs-fix-a-wrong-parameter-in-__scs_magic
+++ a/kernel/scs.c
@@ -135,7 +135,7 @@ static void scs_check_usage(struct task_
 	if (!IS_ENABLED(CONFIG_DEBUG_STACK_USAGE))
 		return;
 
-	for (p = task_scs(tsk); p < __scs_magic(tsk); ++p) {
+	for (p = task_scs(tsk); p < __scs_magic(task_scs(tsk)); ++p) {
 		if (!READ_ONCE_NOCHECK(*p))
 			break;
 		used += sizeof(*p);
_

Patches currently in -mm which might be from zhichi.lin@vivo.com are


