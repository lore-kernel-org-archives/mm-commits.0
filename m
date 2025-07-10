Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C472853EF
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126268; cv=none; b=JMP3njD18EMnwYIBNPhWSDx0/hElLAFiCUavP/OAR2uhWzyH2/RvaualESVopU1XP3FtqviwpHJhWpp+wote8XEGwKadpli2EHhlb/3h1ta3iGRoVC6ty9av0pyU2E8m47kan6meL6LgiqFDXWYlrEoKTmKbvIk/ZhvFwnsHhHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126268; c=relaxed/simple;
	bh=vdQULf4CxB8YNaf/snTciS7e+Zgc2RyqXhuBEF0r+mM=;
	h=Date:To:From:Subject:Message-Id; b=TFw5AJkZNimeAtON7joHaEeHTtcUR0avRgL+lmvxqH7g9LUphyPwQB+Fg/zpIDgxeT1tVrQlAua2iSX4X3j3zyGRk3aOIxFC4ZAPWIjwf7xmUTXE7mqIxZ8LuRFDVnAhdpGSbffioSPawrVJ/Dz1RnqG7i99IVmZZSmypxDTAnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RnQSLS+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RnQSLS+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266D7C4CEE3;
	Thu, 10 Jul 2025 05:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126268;
	bh=vdQULf4CxB8YNaf/snTciS7e+Zgc2RyqXhuBEF0r+mM=;
	h=Date:To:From:Subject:From;
	b=RnQSLS+Gf+x0P15xcwNIbgPp8xzSAYvlx96+z+wYlSJMsaOEdX+OHGabgr2qeajvM
	 Kyx/P+PUgWqc7uGH6WaWDrOYxVeUj6tt4phEAGbDe3M9m+nIiD6P1nq4Z3gvkd+A+j
	 Vk//8Y4/GieShA8g95yC4XmyHz5M9V9TX2C6MRC4=
Date: Wed, 09 Jul 2025 22:44:27 -0700
To: mm-commits@vger.kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd-clarify-error-handling-labels-in-memfd_create.patch removed from -mm tree
Message-Id: <20250710054428.266D7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd: clarify error handling labels in memfd_create()
has been removed from the -mm tree.  Its filename was
     mm-memfd-clarify-error-handling-labels-in-memfd_create.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/memfd: clarify error handling labels in memfd_create()
Date: Tue, 10 Jun 2025 16:37:30 +0800

err_name --> err_free_name (fd failure case)
err_fd --> err_free_fd (file failure case)

Link: https://lkml.kernel.org/r/20250610083730.527619-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memfd.c~mm-memfd-clarify-error-handling-labels-in-memfd_create
+++ a/mm/memfd.c
@@ -475,22 +475,22 @@ SYSCALL_DEFINE2(memfd_create,
 	fd = get_unused_fd_flags((flags & MFD_CLOEXEC) ? O_CLOEXEC : 0);
 	if (fd < 0) {
 		error = fd;
-		goto err_name;
+		goto err_free_name;
 	}
 
 	file = alloc_file(name, flags);
 	if (IS_ERR(file)) {
 		error = PTR_ERR(file);
-		goto err_fd;
+		goto err_free_fd;
 	}
 
 	fd_install(fd, file);
 	kfree(name);
 	return fd;
 
-err_fd:
+err_free_fd:
 	put_unused_fd(fd);
-err_name:
+err_free_name:
 	kfree(name);
 	return error;
 }
_

Patches currently in -mm which might be from liuye@kylinos.cn are


