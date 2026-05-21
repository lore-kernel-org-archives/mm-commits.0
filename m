Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD8D301704
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 23:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779405362; cv=none; b=Ax1kcD7/QWYIdUYNynTB+dNfA4iCSwYHOxW5cU/Kc3NnNsyb44InHca1o6FFHWRpopVKB24xoKTIA+G4oZfzVjAamrxfBBRdcKRjwPYJBSHxrG3nnCvrUXAp5tyWXKSbXxbZMoV6gP/jvOw9UBzBC21/oUgJuG4S6PHPkG6JALo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779405362; c=relaxed/simple;
	bh=1rmQbq28+/wAgJQR4elLxCYaYIKxKubFSQwsAAjT+j8=;
	h=Date:To:From:Subject:Message-Id; b=dnXVVEM0iWeaNx+jZQSbrqY+41pA2zu2qL3x08/ZJ3CgdQwxlQO+aHHw8LsnL31343Iu+n/oWEgwO19Sf+p5XF1qAZOVjZJBls9daE7V2etfCJNKn6Wjiga3+ZLv1lnF5klCqMdX8mTPdIk3nNeMTYYuoqaL6v1Zq0FOVuE+F6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0MKFlPQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0MKFlPQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46141F00A3B;
	Thu, 21 May 2026 23:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779405361;
	bh=LfFbCWwKauvlkfpiD6FuST1VB4h6Z1SC5ihtkX8vpNU=;
	h=Date:To:From:Subject;
	b=0MKFlPQNYtRpLN6y1cSEROjZB1cELT5PmRyu4lw4Byqd7h8jQKOuLZCwZDoQZ4Cj9
	 z4f7jKPye6vE9ckaFQWOt+VOdpFPMHJYKJKlNounG927TcYEUDON5+zUxjPHu9VQ4h
	 idl/2P83uYtJVPLKPPUve1OwDUeghwkxlBNe1JHg=
Date: Thu, 21 May 2026 16:16:00 -0700
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix.patch removed from -mm tree
Message-Id: <20260521231600.E46141F00A3B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: update documentation on remote coverage collection
has been removed from the -mm tree.  Its filename was
     kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix.patch

This patch was dropped because it was folded into kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: kcov: update documentation on remote coverage collection
Date: Tue, 19 May 2026 18:06:06 +0200

Adjust the docs on remote coverage collection to reflect the changes made
in "kcov: refactor common handle ID into kcov_common_handle_id" and "kcov:
allow simultaneous KCOV_ENABLE/KCOV_REMOTE_ENABLE".

Link: https://lore.kernel.org/20260519-kcov-docs-v1-1-5bb22f4cb20c@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Suggested-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/dev-tools/kcov.rst~kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix
+++ a/Documentation/dev-tools/kcov.rst
@@ -246,6 +246,8 @@ KCOV supports collecting remote coverage
 2. Local kernel background tasks. These are spawned when a userspace process
    interacts with some kernel interface and are usually killed when the process
    exits (e.g. vhost workers).
+   This can be combined with another KCOV instance that is configured for normal
+   coverage collection.
 
 3. Soft interrupts.
 
@@ -262,6 +264,9 @@ gets saved to the ``kcov_handle`` field
 needs to be passed to the newly spawned local tasks via custom kernel code
 modifications. Those tasks should in turn use the passed handle in their
 ``kcov_remote_start`` and ``kcov_remote_stop`` annotations.
+In the kernel, common handles are wrapped in a ``kcov_common_handle_id``, which
+consumes no space in builds without ``CONFIG_KCOV``; subsystems that integrate
+with this mechanism should not need to use any ``#ifdef CONFIG_KCOV`` or such.
 
 KCOV follows a predefined format for both global and common handles. Each
 handle is a ``u64`` integer. Currently, only the one top and the lower 4 bytes
_

Patches currently in -mm which might be from jannh@google.com are

kcov-refactor-common-handle-id-into-kcov_common_handle_id.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix.patch

