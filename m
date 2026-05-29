Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F834371898
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028736; cv=none; b=ZJl2vhqE6CK+Aw+sRrfFNEKWhWFAwMUiDFlrI+5ymd24auFZ3qytmL+c+HWlDfx1fjJLNUqUgpnnhGMv8WkXdzuI41VGrMSYBnkf2OT3kGSYh0Y0MLUZ+z1OZJIKsOKfNm1aoRmxv3SAMi4XRG22PLCWV9nkv1QtkcXMfTb0CDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028736; c=relaxed/simple;
	bh=5i+qOZaGi5HMCeTDGy4G/DqrZ8Y+t8v4C/ImbT45PTo=;
	h=Date:To:From:Subject:Message-Id; b=J6LDCD7GLpT1FxVAK6JdcbMVU+ZGyoFcjjHlhm/krCnas9nIGCR68NuZ4dy8HvmLLRaME4dr31iLgWz33GrMIFDNydATzKe8oUJUbPUE05d28LfaQEDSUtFlkdNzHPyA/zR1O7vPIggGvjDWrYwG16Xn1HZiESYrsVIIMGJ7qEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BvZx7lTu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BvZx7lTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A204C1F00893;
	Fri, 29 May 2026 04:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028734;
	bh=vHkaSux0YHTdg5/83jH+HCY9Alhd9rQY3gnYN8ZVqs0=;
	h=Date:To:From:Subject;
	b=BvZx7lTuKYAisSD8SB8a3k4Q7esw9k+L24p/BcRqaukSwyuURIUSxwORwHwUz5qlX
	 eO0ZPvXlcg2QFfhd3gGlVnL7uIyZZ/2jPU+71o247U0LPrBMFrGji12p+7U+VLlJvH
	 sboR8ftsiDBBKv2kaAQm/GN+CxMvXGTvxuFbjdZU=
Date: Thu, 28 May 2026 21:25:34 -0700
To: mm-commits@vger.kernel.org,wangzijie1@honor.com,viro@zeniv.linux.org.uk,jack@suse.cz,brauner@kernel.org,adobriyan@gmail.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-use-strnlen-for-name-validation-in-__proc_create.patch removed from -mm tree
Message-Id: <20260529042534.A204C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: use strnlen() for name validation in __proc_create
has been removed from the -mm tree.  Its filename was
     proc-use-strnlen-for-name-validation-in-__proc_create.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: proc: use strnlen() for name validation in __proc_create
Date: Tue, 21 Apr 2026 14:26:47 +0200

Replace strlen(fn) with strnlen(fn, NAME_MAX + 1) when validating the
final path component in __proc_create().

This preserves the existing name limit while bounding the length scan to
one byte past the maximum name length.  Handle empty names separately, and
treat names longer than NAME_MAX as too long.

Link: https://lore.kernel.org/20260421122648.56723-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: wangzijie <wangzijie1@honor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/proc/generic.c~proc-use-strnlen-for-name-validation-in-__proc_create
+++ a/fs/proc/generic.c
@@ -427,9 +427,13 @@ static struct proc_dir_entry *__proc_cre
 	if (xlate_proc_name(name, parent, &fn) != 0)
 		goto out;
 	qstr.name = fn;
-	qstr.len = strlen(fn);
-	if (qstr.len == 0 || qstr.len >= 256) {
-		WARN(1, "name len %u\n", qstr.len);
+	qstr.len = strnlen(fn, NAME_MAX + 1);
+	if (qstr.len == 0) {
+		WARN(1, "empty name\n");
+		return NULL;
+	}
+	if (qstr.len > NAME_MAX) {
+		WARN(1, "name too long\n");
 		return NULL;
 	}
 	if (qstr.len == 1 && fn[0] == '.') {
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-mseal-use-min-max-in-mseal_apply.patch

