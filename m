Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFBE3D0BE9
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 22:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784586806; cv=none; b=Eqqi+8FZiAqdboHf/Rqa+iHjpPfaEUHFLNYA+j+Q8pZyZObcL4O9Y8WfEF3+Du4TMUiPoaZ/cWrCmN/g3b/Rn7gJ+pjWu4QZ6dNvEAJbFSJQ1Tei2vJE+FofnjW3BG7AyIkLKZ2i22WzRGk+f9NdKTDKKaTEzI5Bd2xSHpqpQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784586806; c=relaxed/simple;
	bh=IW9qv/6c8CtpBS8fzz5E4Wz8kXOzLeJKqa7zsc52CPM=;
	h=Date:To:From:Subject:Message-Id; b=KrNs8I1je6n4eQR4RHohYN3c6QntLO8N5rVU5ea4vi5SP0ZfyDg3MD1OIGlKyBiczzsl1WCnbqYE9SE4fOoUj42KfCDepLJIXDXd7VxJn+p5V5L0xDjjunoPWD36HaIzkxHL9NVRamzB33Io6/rPyTVuxclVJ8PYuhqp1hvYv80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AF7dCvkE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AF7dCvkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A82A1F000E9;
	Mon, 20 Jul 2026 22:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784586800;
	bh=ShEYgRynKqNHOIfbGUO4nEMsCv9LMF6yJo1toCMnc08=;
	h=Date:To:From:Subject;
	b=AF7dCvkEX3rHLORiEXmTD5/usjwJGjOA1PUFan2UcsBCP8vIrDDN401lK+zAgfESr
	 P0ql44Fvi/ZEW3EjdsYR+27OR+hEgdh6YpDFyqyryC9TVAODNyQynywHf8/4/4X7hT
	 3XzPtOd8HFRcHgHd9DhzpKmlBtJoT7pojIBM+nZw=
Date: Mon, 20 Jul 2026 15:33:19 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,paul.white.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-ipc-change-operation-not-supported-error-number.patch added to mm-nonmm-unstable branch
Message-Id: <20260720223320.1A82A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: ipc: change operation not supported error number
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-ipc-change-operation-not-supported-error-number.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-ipc-change-operation-not-supported-error-number.patch

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
From: Paul White <paul.white.kernel@gmail.com>
Subject: selftests: ipc: change operation not supported error number
Date: Mon, 20 Jul 2026 16:40:01 -0400

The application doesn't know what ENOTSUPP means, as it is a kernelspace
error code and the application doesn't have access to kernelspace error
codes.I used EOPNOTSUPP in its place as that is an error number the
application will recognize and know an operation is being attempted that
it cannot support.

Link: https://lore.kernel.org/20260720204001.1663473-1-paul.white.kernel@gmail.com
Signed-off-by: Paul White <paul.white.kernel@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/ipc/msgque.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/ipc/msgque.c~selftests-ipc-change-operation-not-supported-error-number
+++ a/tools/testing/selftests/ipc/msgque.c
@@ -161,7 +161,7 @@ int dump_queue(struct msgque_data *msgqu
 		ret = msgrcv(msgque->msq_id, &msgque->messages[i].mtype,
 				MAX_MSG_SIZE, i, IPC_NOWAIT | MSG_COPY);
 		if (ret < 0) {
-			if (errno == ENOSYS)
+			if (errno == EOPNOTSUPP)
 				ksft_exit_skip("MSG_COPY not supported\n");
 
 			ksft_test_result_fail("Failed to copy IPC message: %m (%d)\n", errno);
_

Patches currently in -mm which might be from paul.white.kernel@gmail.com are

selftests-ipc-change-operation-not-supported-error-number.patch

