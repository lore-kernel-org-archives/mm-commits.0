Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622F8279782
	for <mm-commits@vger.kernel.org>; Sat, 11 Oct 2025 17:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760202727; cv=none; b=OSuyyWS8PVVnw4DHFGBh7tG6Ort9thtf6qy/JWF4oWehcWLvSjWCPANZLbG3JIn+c0MAau8AIk0rDFdpjyD2uaSUhhownX3UPfQqziGCuzONGZ04wBXAQr8A1MxPMZO0Pdk6e4gb7n9U7OVMR8lx/qKG3XbOwDru0P2WbMDL71Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760202727; c=relaxed/simple;
	bh=mgn7JxIW4Lt72ciQ4aATsxu/s5iArnoj1fRqKzD36q8=;
	h=Date:To:From:Subject:Message-Id; b=PgSN0B0VgGwCEekXMDgXlpdQ2S+jBpgwUKCENbzP+7AZQozCnV0KmEhMh+PvCS3J7UMD8BT8jy8ueCFVTyX+lvGbko4Lzu8PkSN2a3vz+BEXjj/WDE9ypnbfqWw7ddyH48KGCKFzRqRAKhYiAIAWhXw8HzCSRWwoJUmefI7ljMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w2knmVM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w2knmVM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB993C4CEF4;
	Sat, 11 Oct 2025 17:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760202726;
	bh=mgn7JxIW4Lt72ciQ4aATsxu/s5iArnoj1fRqKzD36q8=;
	h=Date:To:From:Subject:From;
	b=w2knmVM0N2hUPvG9f7N5mqS20tVBmSZDsV3LpW0gVClcqwp0o7Foqe9zklRhoQRJy
	 r4huRJUr7UGklA8aEx4A0uYeepGVXV1x+akG5/wWii/QKzT/olPY/NAjCfWxefgMWs
	 mdhC+87Wr54JF5oAv0ewjNVMYKlW/r1eB8xwENTI=
Date: Sat, 11 Oct 2025 10:12:06 -0700
To: mm-commits@vger.kernel.org,yee.lee@mediatek.com,xiejiyuan@vivo.com,will@kernel.org,samitolvanen@google.com,keescook@chromium.org,elver@google.com,andreyknvl@gmail.com,zhichi.lin@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scs-fix-a-wrong-parameter-in-__scs_magic.patch added to mm-nonmm-unstable branch
Message-Id: <20251011171206.DB993C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scs: fix a wrong parameter in __scs_magic
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scs-fix-a-wrong-parameter-in-__scs_magic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scs-fix-a-wrong-parameter-in-__scs_magic.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Zhichi Lin <zhichi.lin@vivo.com>
Subject: scs: fix a wrong parameter in __scs_magic
Date: Sat, 11 Oct 2025 16:22:22 +0800

__scs_magic() needs a 'void *' variable, but a 'struct task_struct *' is
given.  'task_scs(tsk)' is the starting address of the task's shadow call
stack, and '__scs_magic(task_scs(tsk))' is the end address of the task's
shadow call stack.  Here should be '__scs_magic(task_scs(tsk))'.

Link: https://lkml.kernel.org/r/20251011082222.12965-1-zhichi.lin@vivo.com
Fixes: 5bbaf9d1fcb9 ("scs: Add support for stack usage debugging")
Signed-off-by: Jiyuan Xie <xiejiyuan@vivo.com>
Signed-off-by: Zhichi Lin <zhichi.lin@vivo.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yee Lee <yee.lee@mediatek.com>
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

scs-fix-a-wrong-parameter-in-__scs_magic.patch

