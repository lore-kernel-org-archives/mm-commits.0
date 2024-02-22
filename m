Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918F9137931
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645178; cv=none; b=eKGk4LPQCMbPJHbLdj5amwrepwiTZW06VnkBPWtycDwxkUaXfxt9XzJzbx8FPuH6i/26XHuvkFY0MK/Y9cMHCQNPdQ6BIXbmr+MqOVgXrUII3Iy3T3HhvAixyhqO8ieYHU6g0wsceA34EVEl88JFcoa9WMBsRjIc7Ws8R6Quw7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645178; c=relaxed/simple;
	bh=cZEexMd+ELkuxCy5VJWqbnj/ai5ubpUg2h0RP90APzQ=;
	h=Date:To:From:Subject:Message-Id; b=VitDvDdFj1Q9VdaONR1fCPEjJuMlyNiPhzVDVjQXC+KgYH5+to9l+xEN5dWCLkbDr3vphKVhZPe7BdF680+vqKsx7hChiiBO//XLprT8luxg/2sDV/Ufb6QNoR3IJMiXM4254fUFd/wm4IKfFg9dKfk0bfR9WDOHMEtyGwz5+Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D1vzXFAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D1vzXFAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17024C433F1;
	Thu, 22 Feb 2024 23:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645178;
	bh=cZEexMd+ELkuxCy5VJWqbnj/ai5ubpUg2h0RP90APzQ=;
	h=Date:To:From:Subject:From;
	b=D1vzXFAuD/6voAGni8387/Jwu4tUmbrRUYym1ZUxcnSQjP7j19qSDsRR4qef49hKo
	 zs3OAq/Mq3V32Y8Lw5JUgAGD8jnOJqy6/QhVhDp7gTJCc131JR1A1B57EbBe+23/95
	 Yj8HzoEX9/3IncgtQp0uV1ufP6dlt8amoWW7m9/A=
Date: Thu, 22 Feb 2024 15:39:37 -0800
To: mm-commits@vger.kernel.org,mcgrof@kernel.org,manfred@colorfullife.com,keescook@chromium.org,joel.granados@gmail.com,ebiederm@xmission.com,dave@stgolabs.net,brauner@kernel.org,legion@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] docs-add-information-about-ipc-sysctls-limitations.patch removed from -mm tree
Message-Id: <20240222233938.17024C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: add information about ipc sysctls limitations
has been removed from the -mm tree.  Its filename was
     docs-add-information-about-ipc-sysctls-limitations.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


