Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45C220B33
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 20:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705435744; cv=none; b=pxCBkuSqdKDhC2BIPT4rWXTNAnGCOH40YlDX4mp10DAGhnlGmobjVEk7bImklvjGn9bE1fwguqHHihi9lUt96XqnGLbUm84krhfKe4X7+Kud6NEKmC/sQTf44t3Tfe2Reh7y1ylR7ZI+qQ/G+yeFlhGPi9AVVupE+bpLjxlIgP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705435744; c=relaxed/simple;
	bh=rNXjPYUJRVg1KrkMThLmvyXtSIGHdfM3w71AG2yzANI=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=KJ1CvU/tkejhl8XS+0bzcinU9nX2psPrlES7Vq0r6VmhBrAwGs4RRCYHnCu3Fzf7MyMBmnqF9V/8WQjahcx0y3N1pUNWIo0xAB6Of8Qh+B2eAOVzuZN9C0eauuRVG92Y3CAorWI0vkjVXaICbJ78VSbDMOx/5YFWJ3MyJGaG9WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O0e0joiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O0e0joiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154B6C433C7;
	Tue, 16 Jan 2024 20:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705435744;
	bh=rNXjPYUJRVg1KrkMThLmvyXtSIGHdfM3w71AG2yzANI=;
	h=Date:To:From:Subject:From;
	b=O0e0joiYTCtRZQCbGc9uy51hWgrk2QMrCRyWHOzqVe5m3AEAEWWLeq6DCMr5TIOUP
	 iXmZRpj3ZTm++JFk5TV0t2JHx6ncYfavBV5iniupGGj8UEQkUsYx+7xP+2UPk2UsCg
	 MpDUw/zmAWTznrzjh5Gc/TUqiBCCmJbu7KalMPbw=
Date: Tue, 16 Jan 2024 12:09:01 -0800
To: mm-commits@vger.kernel.org,mcgrof@kernel.org,manfred@colorfullife.com,keescook@chromium.org,joel.granados@gmail.com,ebiederm@xmission.com,dave@stgolabs.net,brauner@kernel.org,legion@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-add-information-about-ipc-sysctls-limitations.patch added to mm-nonmm-unstable branch
Message-Id: <20240116200904.154B6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: add information about ipc sysctls limitations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     docs-add-information-about-ipc-sysctls-limitations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-add-information-about-ipc-sysctls-limitations.patch

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
From: Alexey Gladkov <legion@kernel.org>
Subject: docs: add information about ipc sysctls limitations
Date: Mon, 15 Jan 2024 15:46:42 +0000

After 25b21cb2f6d6 ("[PATCH] IPC namespace core") and 4e9823111bdc
("[PATCH] IPC namespace - shm") the shared memory page count stopped being
global and started counting per ipc namespace.  The documentation and
shmget(2) still says that shmall is a global option.

shmget(2):

SHMALL System-wide limit on the total amount of shared memory, measured in
units of the system page size.  On Linux, this limit can be read and
modified via /proc/sys/kernel/shmall.

I think the changes made in 2006 should be documented.

Link: https://lkml.kernel.org/r/09e99911071766958af488beb4e8a728a4f12135.1705333426.git.legion@kernel.org
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Link: https://lkml.kernel.org/r/ede20ddf7be48b93e8084c3be2e920841ee1a641.1663756794.git.legion@kernel.org
Cc: Christian Brauner <brauner@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Joel Granados <joel.granados@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~docs-add-information-about-ipc-sysctls-limitations
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -594,6 +594,9 @@ default (``MSGMNB``).
 ``msgmni`` is the maximum number of IPC queues. 32000 by default
 (``MSGMNI``).
 
+All of these parameters are set per ipc namespace. The maximum number of bytes
+in POSIX message queues is limited by ``RLIMIT_MSGQUEUE``. This limit is
+respected hierarchically in the each user namespace.
 
 msg_next_id, sem_next_id, and shm_next_id (System V IPC)
 ========================================================
@@ -1274,15 +1277,20 @@ are doing anyway :)
 shmall
 ======
 
-This parameter sets the total amount of shared memory pages that
-can be used system wide. Hence, ``shmall`` should always be at least
-``ceil(shmmax/PAGE_SIZE)``.
+This parameter sets the total amount of shared memory pages that can be used
+inside ipc namespace. The shared memory pages counting occurs for each ipc
+namespace separately and is not inherited. Hence, ``shmall`` should always be at
+least ``ceil(shmmax/PAGE_SIZE)``.
 
 If you are not sure what the default ``PAGE_SIZE`` is on your Linux
 system, you can run the following command::
 
 	# getconf PAGE_SIZE
 
+To reduce or disable the ability to allocate shared memory, you must create a
+new ipc namespace, set this parameter to the required value and prohibit the
+creation of a new ipc namespace in the current user namespace or cgroups can
+be used.
 
 shmmax
 ======
_

Patches currently in -mm which might be from legion@kernel.org are

sysctl-allow-change-system-v-ipc-sysctls-inside-ipc-namespace.patch
docs-add-information-about-ipc-sysctls-limitations.patch
sysctl-allow-to-change-limits-for-posix-messages-queues.patch

