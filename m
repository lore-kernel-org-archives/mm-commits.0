Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391FB286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127187; cv=none; b=rGxJ/23Aj0vKZMD+uFY2W31the98vvgSIsGiGL0SKcWXUs9AMS0UYZyNH8iPArIkFo9nqlH1ZMwkLClIM8wE2OborrR8vWxPKLADZ9+/1+aPyv7NYinFYgOsR/HPhOnJ7P1TE4rVaO88QnbzKrMlViIrVahO6EHIwDndmUxMXSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127187; c=relaxed/simple;
	bh=PYl45ZrM5f3zrns5f3VJzG/hsJmJX6kxjJKblNURnOo=;
	h=Date:To:From:Subject:Message-Id; b=Ee+rQxCiratLUfHw+ZsVv74P018bIROfURoD3NUqn3Jsu4HqapnVOU/RWlVVrZk9e5DG/2nJUrvnu0vHYhfI3Uw9UDT0XPi1bJ3BCxg1yqm0NoND4FWKWW5rHHJVby0T4B13TZXUq7Y4EB7nUdmtoMZ/Okb/2414tALtlMCbOT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vKT+ip/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vKT+ip/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B38EC4CEE3;
	Thu, 10 Jul 2025 05:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127187;
	bh=PYl45ZrM5f3zrns5f3VJzG/hsJmJX6kxjJKblNURnOo=;
	h=Date:To:From:Subject:From;
	b=vKT+ip/WeJnv3c+8oop6zfJHOHjUH5jKNliTrqroDFVoVI+wlbdblwtA/3TFc/w0z
	 +mvG1snXPgd2uo/fwqAXZmwzkJR1acsvOWYkB4KyhlvPjaq5n4a8R3WmDg9xePpF4V
	 cLxwI4iXa857se4YhTgytbjLvbccGOxav8dB88ek=
Date: Wed, 09 Jul 2025 22:59:46 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,oleg@redhat.com,ldv@strace.io,moonhee.lee.ca@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-ptrace-add-set_syscall_info-to-gitignore.patch removed from -mm tree
Message-Id: <20250710055947.0B38EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: ptrace: add set_syscall_info to .gitignore
has been removed from the -mm tree.  Its filename was
     selftests-ptrace-add-set_syscall_info-to-gitignore.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Subject: selftests: ptrace: add set_syscall_info to .gitignore
Date: Mon, 23 Jun 2025 11:34:06 -0700

Add the set_syscall_info test binary to .gitignore to avoid tracking build
artifacts in the ptrace selftests directory.

Link: https://lkml.kernel.org/r/20250623183405.133434-2-moonhee.lee.ca@gmail.com
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Cc: "Dmitry V. Levin" <ldv@strace.io>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/ptrace/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/ptrace/.gitignore~selftests-ptrace-add-set_syscall_info-to-gitignore
+++ a/tools/testing/selftests/ptrace/.gitignore
@@ -3,3 +3,4 @@ get_syscall_info
 get_set_sud
 peeksiginfo
 vmaccess
+set_syscall_info
_

Patches currently in -mm which might be from moonhee.lee.ca@gmail.com are


