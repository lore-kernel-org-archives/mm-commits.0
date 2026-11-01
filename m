Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793504342;
	b=ZK7yzklPBB9VLDb9y6WyHhPp5fEypYd71/9SJtCCYpHiBY3kqJObEKQlJ9koJbB3OzrZ
	 /dBfeYRyriW/qRT/NexG5V4XDr6eLI73y+U7vPpPOVA7q+g4bgW1LM5rLrXL0x87s4kjM
	 zVhXKtqrc0wxbITTIHVdH9o+BkKNWF8sejURuba/AOfi3lxuLYMtN9w02+Hvwx/mb9F1G
	 7WvhYtX5o2iUotIGcbu+Xgdg+P30e7/JqTSYuYpcm/uJ3qg5Sw58v2RwTUV0nzlToEz9p
	 Fp6W918wtpMcNLzMKtJ9xsSc3m1Tang8Dskqnf4K7D8u1KB1YqRtUC98i2pCDU/E7yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793504342;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=8WvLBNywTRkBo6HPyt44/MH33Yh7FqpzZTb+4PBqLGM=;
	b=Bw2iFHY7ZXhEYNdbExvxxWVN8yz7q9TosFmoeI2VbDuAPNQCFnsVjRainf7qsuOfyyqs
	 fXgatm4pPWDFp24/tY4yvYPqFjYI1QUP0GkYTobF+GpCfzb3KQTpiDcd1/XKN2El1bk5R
	 xlqbbc9h01HCnbm1L36RSQm1n/FelBZnw3ilhbkSaz660NHvKLteiCyK5nPDnHMtKZsLq
	 umV2Ls2ou5Aqs/LIEZYafjBOco79zegsj/tlYL8voudMY0rFOY8duLv4rHaftYbiFXzrx
	 XGo9Ho4z/jX7fOQBstkeWTLYcetyKhUl7NPecr8YDlk9eMpDJbDB7X+ywDL3MfJZOYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AJQTtPUy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8C9606A324;
	Sun,  1 Nov 2026 03:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AJQTtPUy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFB61F000C1;
	Sun,  1 Nov 2026 03:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793504341;
	bh=8WvLBNywTRkBo6HPyt44/MH33Yh7FqpzZTb+4PBqLGM=;
	h=Date:To:From:Subject;
	b=AJQTtPUywdIrB6sRVgRiEPFum+U08RAfFo8avQNB+B1dLm+KTD+qYvl64HJQ1CPLp
	 4xBSneuLqoq9/JeetqH+ISCvFGknf6sajjylpu7Aagkaj7cMwR9XwtdMSJzqJRAGVe
	 YAwSBzrfB8vmhwFYo/UoAwyB5Ptsdus2JhOVUbD8=
Date: Sat, 31 Oct 2026 20:39:01 -0700
To: mm-commits@vger.kernel.org,yuantan098@gmail.com,yifanwucs@gmail.com,
	tomapufckgml@gmail.com,stable@vger.kernel.org,
	schuster.simon@siemens-energy.com,n05ec@lzu.edu.cn,manfred@colorfullife.com,
	ljs@kernel.org,kees@kernel.org,enjou1224z@gmail.com,david@kernel.org,
	dave@stgolabs.net,bird@lzu.edu.cn,arnd@arndb.de,caoruide123@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-sem-fix-used_sems-overflow-in-newary.patch added to mm-nonmm-unstable branch
Message-Id: <20261101033901.7DFB61F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ipc: sem: fix used_sems overflow in newary()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-sem-fix-used_sems-overflow-in-newary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-sem-fix-used_sems-overflow-in-newary.patch

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
From: Ruide Cao <caoruide123@gmail.com>
Subject: ipc: sem: fix used_sems overflow in newary()
Date: Mon, 11 May 2026 18:42:53 +0800

newary() checks namespace-wide semaphore usage before creating a new
array, but the current accounting uses a plain signed addition.

If the accumulated semaphore count overflows, the limit check can fail
open and allow allocations past sc_semmns, breaking namespace semaphore
resource enforcement and potentially leading to resource exhaustion.

Fix this by using check_add_overflow() before comparing the new total
against sc_semmns, and reject overflow the same way as a true limit
exceed.

Link: https://lore.kernel.org/849fb1fdecd1cc241fd5b032602dbffa90f9dd93.1778477179.git.caoruide123@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Simon Schuster <schuster.simon@siemens-energy.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>
---

 ipc/sem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/ipc/sem.c~ipc-sem-fix-used_sems-overflow-in-newary
+++ a/ipc/sem.c
@@ -535,11 +535,13 @@ static int newary(struct ipc_namespace *
 	key_t key = params->key;
 	int nsems = params->u.nsems;
 	int semflg = params->flg;
+	int total_sems;
 	int i;
 
 	if (!nsems)
 		return -EINVAL;
-	if (ns->used_sems + nsems > ns->sc_semmns)
+	if (check_add_overflow(ns->used_sems, nsems, &total_sems) ||
+	    total_sems > ns->sc_semmns)
 		return -ENOSPC;
 
 	sma = sem_alloc(nsems);
_

Patches currently in -mm which might be from caoruide123@gmail.com are

ipc-sem-fix-used_sems-overflow-in-newary.patch

