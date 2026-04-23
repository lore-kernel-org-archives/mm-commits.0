Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A98312807
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 15:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776956942; cv=none; b=dUR+pcEWy4Uf07f4NJ3aNewYVPOXZu+awVAHG0uPsI/MC1ZvPzpnXFfpHIWmvNHLVaKzub4GPtrIMJIQJTgB128wkI1NXOKGZqktftsc1cLnZXnnTSVG8+jKfsxBzbTuxwaELu8EezHp2Sc5MaSkeHkBClpqZ75BM83wirX0MWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776956942; c=relaxed/simple;
	bh=Ora24AEeLB8W5dR218PHUVVLeP2ymywH+v+ZN5VMoi4=;
	h=Date:To:From:Subject:Message-Id; b=j5Hu6cBJm8U50MP1GNZr+gneW2VTsjbB6LlvEe84hxoi93BOQVBuev5TEVlzDZz7aqZvtyfZwr2TD6G8BA8uDCpGTbAvYjv012zvUiObSCu0VomNx1hupyLsaiP6rjZtxeEkDrIpnODQ+0MPIkYaTVqUCH1/QJyRublHrceQG04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tTT+PuI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tTT+PuI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B74C2BCAF;
	Thu, 23 Apr 2026 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776956941;
	bh=Ora24AEeLB8W5dR218PHUVVLeP2ymywH+v+ZN5VMoi4=;
	h=Date:To:From:Subject:From;
	b=tTT+PuI6hMECTUuTAitwbhLNgMO7ZYUdi8CvEpkzbxU0eDHRnPyv7o43KWbQ0v/jg
	 Quz6Y44J38KalTdCzcLPxJfJWoflc6vfj14WTvk5qScD4i0PpIjveq3wQEryNOL2h1
	 hzy0U2FdlFNm98rDU6j0Q8qHL4p08OFa9RO598Ws=
Date: Thu, 23 Apr 2026 08:09:00 -0700
To: mm-commits@vger.kernel.org,wangzijie1@honor.com,viro@zeniv.linux.org.uk,jack@suse.cz,brauner@kernel.org,adobriyan@gmail.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-use-strnlen-for-name-validation-in-__proc_create.patch added to mm-nonmm-unstable branch
Message-Id: <20260423150901.74B74C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: use strnlen() for name validation in __proc_create
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-use-strnlen-for-name-validation-in-__proc_create.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-use-strnlen-for-name-validation-in-__proc_create.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

proc-use-strnlen-for-name-validation-in-__proc_create.patch

