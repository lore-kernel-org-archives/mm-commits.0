Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45ABB30E836
	for <mm-commits@vger.kernel.org>; Wed,  2 Jul 2025 18:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751479667; cv=none; b=W6G7Bz7tzGxCaKTMv5AQgp059+KF8WWl+cv0Pk96muRSflyz8mxiJI4zOmFl4XX493PqKAP3MTfX/AqarDF0K3pLQNsqLNEMN6mdH2QfzB7gK6wk853WHk+d6kLxaJxVnLNS4E/rBX3xQsafRaWU3PagXUWIZPG2577XNNnOnPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751479667; c=relaxed/simple;
	bh=PZWEJPdp30pXoPINMl0ZGlstogF2NKuaHlAIcQew+40=;
	h=Date:To:From:Subject:Message-Id; b=Q3ydoEx07bDwz6N0g10eP8q0nJ2PgdE/Iv0KG0Z6sn9f/1WvPVpft+YDnmLH398zqgwykQv78K9H0TDYMgqPWp701MUFyfVZo3G+MVJ+gB2s1ymdisltyDjaMsGofNPbVA7L/S22WmiLm6MtkdJ3avYN5SAxgq4qtZzZ9tT7fsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VWKzy5ik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VWKzy5ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA00CC4CEEE;
	Wed,  2 Jul 2025 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751479666;
	bh=PZWEJPdp30pXoPINMl0ZGlstogF2NKuaHlAIcQew+40=;
	h=Date:To:From:Subject:From;
	b=VWKzy5ikxxZqn4iDSkv5i32v/9i3ddTKu5wpv991BzOzjJfRjEzLZZijnocOj5Rbe
	 AhU47QSdHD1jNcWK41v6U1WEPX0DVV6NG8hRmCjtDKfiw+NWiUO+S/dXFFG6yy1zQb
	 TmWItzQ8OT+EJ6JhdDDuHD6o5mnJdrEewJTBu4Wk=
Date: Wed, 02 Jul 2025 11:07:46 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,oleg@redhat.com,ldv@strace.io,moonhee.lee.ca@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-ptrace-add-set_syscall_info-to-gitignore.patch added to mm-nonmm-unstable branch
Message-Id: <20250702180746.DA00CC4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: ptrace: add set_syscall_info to .gitignore
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-ptrace-add-set_syscall_info-to-gitignore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-ptrace-add-set_syscall_info-to-gitignore.patch

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

selftests-mm-remove-duplicate-gitignore-entries.patch
selftests-ptrace-add-set_syscall_info-to-gitignore.patch

