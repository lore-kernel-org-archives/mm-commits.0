Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80164423E8A
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816344; cv=none; b=cvwNzqR9sFXqbeIQZCpsan443PXVZm0aHjoJm6MlVaMbT6tzXPVm5FOsQv15Vb9T3BOi7UNN+MlcnTeakPVVXHNigvrK/NoTrBXwuYg7rGB2Xu+TAUi8hMweLkGS4nkH7Wzx9xofVtHLpaRNkdhf84ytIsBp10iIv4mDP3074Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816344; c=relaxed/simple;
	bh=OhB4A4sp96PSAlS/ZWqBPRTyIK5vPM9KVPvVZcR6ipo=;
	h=Date:To:From:Subject:Message-Id; b=rWXi49+QXTgtGhmVQvIn5Q/Mlp4mumD2rNRa+nxXHoypMUQdUVS5g7krjJ3GcKXbujSj7eEHq8dCA4THs62FQwy30+2Pb/gCmn9gwR5KBs6XsHC2nKSzdKYiptwl63/zatHRd4seipKb+iV9sT3DlSojGGRsmKIXP4S8k20i2ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HjYZzm0E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HjYZzm0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5583D1F00A3A;
	Tue,  4 Aug 2026 04:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816343;
	bh=rr4PD+R3lm0HvOeqCOn+03If9a6TLYsJAH+Y50i0cz8=;
	h=Date:To:From:Subject;
	b=HjYZzm0E/wFkfypvdcv2KCdNqY38PWbfqoX/ogLKjQEPgRlvuVBStB+/9JA5SRcdJ
	 Znzu7fu2OYc6vgopP4FKrhUmEg42OLHX0wKRSv8Ej+6SZYiUA4DPEqb3zrWCYeIz27
	 yczA589vhprQQddvwz/o5G238jOa+nKs/1XM7dzs=
Date: Mon, 03 Aug 2026 21:05:42 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,paul.white.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-ipc-change-operation-not-supported-error-number.patch removed from -mm tree
Message-Id: <20260804040543.5583D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: ipc: change operation not supported error number
has been removed from the -mm tree.  Its filename was
     selftests-ipc-change-operation-not-supported-error-number.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


