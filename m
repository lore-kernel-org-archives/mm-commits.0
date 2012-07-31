From: akpm@linux-foundation.org
Subject: [merged] proc-environ_read-make-sure-offset-points-to-environment-address-range.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:53:46 -0700
Message-ID: <20120731185346.E0027100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2GaSxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:53:48 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:53:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tixxdz@opendz.org, keescook@chromium.org, oleg@redhat.com, rientjes@google.com, spender@grsecurity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: environ_read() make sure offset points to environment address range
has been removed from the -mm tree.  Its filename was
     proc-environ_read-make-sure-offset-points-to-environment-address-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Djalal Harouni <tixxdz@opendz.org>
Subject: proc: environ_read() make sure offset points to environment address range

Currently the following offset and environment address range check in
environ_read() of /proc/<pid>/environ is buggy:

int this_len = mm->env_end - (mm->env_start + src);
if (this_len <= 0)
	break;

Large or negative offsets on /proc/<pid>/environ converted to 'unsigned
long' may pass this check since '(mm->env_start + src)' can overflow and
'this_len' will be positive.

This can turn /proc/<pid>/environ to act like /proc/<pid>/mem since
(mm->env_start + src) will point and read from another VMA.

There are two fixes here plus some code cleaning:

1) Fix the overflow by checking if the offset that was converted to
   unsigned long will always point to the [mm->env_start, mm->env_end]
   address range.

2) Remove the truncation that was made to the result of the check,
   storing the result in 'int this_len' will alter its value and we can
   not depend on it.

For kernels that have commit b409e578d ("proc: clean up
/proc/<pid>/environ handling") which adds the appropriate ptrace check and
saves the 'mm' at ->open() time, this is not a security issue.

This patch is taken from the grsecurity patch since it was just made
available.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Brad Spengler <spender@grsecurity.net>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/proc/base.c~proc-environ_read-make-sure-offset-points-to-environment-address-range fs/proc/base.c
--- a/fs/proc/base.c~proc-environ_read-make-sure-offset-points-to-environment-address-range
+++ a/fs/proc/base.c
@@ -827,15 +827,16 @@ static ssize_t environ_read(struct file 
 	if (!atomic_inc_not_zero(&mm->mm_users))
 		goto free;
 	while (count > 0) {
-		int this_len, retval, max_len;
+		size_t this_len, max_len;
+		int retval;
 
-		this_len = mm->env_end - (mm->env_start + src);
