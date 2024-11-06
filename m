Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96B3188917
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855607; cv=none; b=Hj1AvxOmAVEANDmCEOz7EBQHgQyDxCQUYEtrfB3fCjgB8UluV/Buxj55Zkm0IrghjXXNcGTQQwPsKo4kzT69McF4quUjd/YdcM1VV0GLnAFW4wJVLVm02CmjSp8ueXLmN6j74Zp6dAeq9K4QpMLWR1qQd56Byx9rLFQTy2e0SyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855607; c=relaxed/simple;
	bh=8wjkjTw7HqWQ9AiahB+kH15YddIkW02AR67z7qP3S7g=;
	h=Date:To:From:Subject:Message-Id; b=RsAPg5eXELZCuxlMB396yLbQlytiJQfrAp+Zne9Uk+Wtin79m/KKjp3rc8EXbt1K9tJplxeOhM7eOQEvCIrkxMnAooLcSsNp1mshao27gpIQ7s7etoGLGXPfr4i3CkfpVQrZNp6p885qezLFA869AhjbjoqljgfwEElNY2WZk/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q31N/wkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q31N/wkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634ADC4CECF;
	Wed,  6 Nov 2024 01:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855607;
	bh=8wjkjTw7HqWQ9AiahB+kH15YddIkW02AR67z7qP3S7g=;
	h=Date:To:From:Subject:From;
	b=q31N/wkvm7saZ/gx53XRrRoID4XtO3HUvQ/mkqROOLgj5wQolMIzjXwG6nm7Lr06G
	 OQuqXFRBFy1QBr7yqgE3KgBn/BnH+YA+2oEz7YWtCGgy12AY5qFmK66qIyXLkrBtjf
	 de3KjbiLEQzG+XNYxz/67pAlBIs8tzolOrBP5dds=
Date: Tue, 05 Nov 2024 17:13:26 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,jiebin.sun@intel.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-msg-replace-one-element-array-with-flexible-array-member.patch removed from -mm tree
Message-Id: <20241106011327.634ADC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ipc/msg: replace one-element array with flexible array member
has been removed from the -mm tree.  Its filename was
     ipc-msg-replace-one-element-array-with-flexible-array-member.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: ipc/msg: replace one-element array with flexible array member
Date: Mon, 30 Sep 2024 21:58:22 +0200

Replace the deprecated one-element array with a modern flexible array
member in the struct compat_msgbuf.

There are no binary differences after this conversion.

Link: https://github.com/KSPP/linux/issues/79
Link: https://lkml.kernel.org/r/20240930195824.153648-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Sun, Jiebin" <jiebin.sun@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/msg.c~ipc-msg-replace-one-element-array-with-flexible-array-member
+++ a/ipc/msg.c
@@ -978,7 +978,7 @@ SYSCALL_DEFINE4(msgsnd, int, msqid, stru
 
 struct compat_msgbuf {
 	compat_long_t mtype;
-	char mtext[1];
+	char mtext[];
 };
 
 long compat_ksys_msgsnd(int msqid, compat_uptr_t msgp,
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mailmap-add-entry-for-thorsten-blum.patch
mm-show_mem-use-str_yes_no-helper-in-show_free_areas.patch

