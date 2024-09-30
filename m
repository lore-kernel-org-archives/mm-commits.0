Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF0B194082
	for <mm-commits@vger.kernel.org>; Mon, 30 Sep 2024 21:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727730561; cv=none; b=ffaDQORwf6ujLISqBCa1YcqMbjyrMx3n8AZ5XgQ8XkD2hqW7IC08xTaU8VIrJXaQKfzx3hsErq/oOwoUHHhimaRdd1h2tXWe++keoKCtXTbtZhhP9LTJvpoPxpudB8HRCtW8jYMmigwJPaKd1PCeKuYm/H5uhxsFCspjetzLv08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727730561; c=relaxed/simple;
	bh=tGDTNLq91N3jqeYjUtf8P2o8Q2ifxlVDMA7UzCQxkiU=;
	h=Date:To:From:Subject:Message-Id; b=qN6Zwg6ufezmRMQo/v+CChtpAvznkQTKIrKUg4LQWZJzfYGVsRSLndKKIMF2uGWShTlNfa3mh4rgkOjw0LYjjhKIERfXdEMaXFEvM0pA/xo4u7GLCkRlnzgdNpi/yV8OK010fp2PdkoV2yw+zCUFsEKvw692d6bIUa4OpeioO24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D6g0D6L3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D6g0D6L3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CC8C4CEC7;
	Mon, 30 Sep 2024 21:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727730560;
	bh=tGDTNLq91N3jqeYjUtf8P2o8Q2ifxlVDMA7UzCQxkiU=;
	h=Date:To:From:Subject:From;
	b=D6g0D6L3Hso49VmOGcX4/do5aArDCSdvwAcwQT2Bt1POGTki8dd+S3q72Wtgv/Gaj
	 qX/jqGI+VHsyDlA/3RQ7XfgvWhHMj0YmPeI2pzfdry5pLWOiff4OYlwpMrgJAB5EZb
	 X8aPekQfaml7QNxZa7VFiyEvMcj9m4eJQLvlWXj4=
Date: Mon, 30 Sep 2024 14:09:18 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,jiebin.sun@intel.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-msg-replace-one-element-array-with-flexible-array-member.patch added to mm-nonmm-unstable branch
Message-Id: <20240930210920.62CC8C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc/msg: replace one-element array with flexible array member
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-msg-replace-one-element-array-with-flexible-array-member.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-msg-replace-one-element-array-with-flexible-array-member.patch

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

ipc-msg-replace-one-element-array-with-flexible-array-member.patch

