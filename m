From: akpm@linux-foundation.org
Subject: - mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:51 -0700
Message-ID: <200804282151.m3SLpp1t017609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965002AbYD1VwD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, eric.whitney@hp.com, lee.schermerhorn@hp.com, pj@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: fix parsing of tmpfs mpol mount option
has been removed from the -mm tree.  Its filename was
     mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: fix parsing of tmpfs mpol mount option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Parsing of new mode flags in the tmpfs mpol mount option is slightly broken:

Setting a valid flag works OK:
	#mount -o remount,mpol=bind=static:1-2 /dev/shm
	#mount
	...
	tmpfs on /dev/shm type tmpfs (rw,mpol=bind=static:1-2)
	...

However, we can't remove them or change them, once we've
set a valid flag:

	#mount -o remount,mpol=bind:1-2 /dev/shm
	#mount
	...
	tmpfs on /dev/shm type tmpfs (rw,mpol=bind:1-2)
	...

It SAYS it removed it, but that's just a copy of the input
string.  If we now try to set it to a different flag, we
get:

	#mount -o remount,mpol=bind=relative:1-2 /dev/shm
	mount: /dev/shm not mounted already, or bad option

And on the console, we see:
	tmpfs: Bad value 'bind' for mount option 'mpol'
	                      ^ lost remainder of string

Furthermore, bogus flags are accepted with out error.
Granted, they are a no-op:

	#mount -o remount,mpol=interleave=foo:0-3 /dev/shm
	#mount
	...
	tmpfs on /dev/shm type tmpfs (rw,mpol=interleave=foo:0-3)

Again, that's just a copy of the input string shown by the mount command.

This patch fixes the behavior by pre-zeroing the flags so that only one of the
mutually exclusive flags can be set at one time.  It also reports an error
when an unrecognized flag is specified.

The check for both flags being set is removed because it can't happen with
this implementation.  If we ever want to support multiple non-exclusive flags,
this area will need rework and we will need to check that any mutually
exclusive flags aren't specified.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Eric Whitney <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN mm/shmem.c~mempolicy-fix-parsing-of-tmpfs-mpol-mount-option mm/shmem.c
--- a/mm/shmem.c~mempolicy-fix-parsing-of-tmpfs-mpol-mount-option
+++ a/mm/shmem.c
@@ -1125,20 +1125,26 @@ static int shmem_parse_mpol(char *value,
 			*policy_nodes = node_states[N_HIGH_MEMORY];
 		err = 0;
 	}
+
+	*mode_flags = 0;
 	if (flags) {
+		/*
+		 * Currently, we only support two mutually exclusive
+		 * mode flags.
+		 */
 		if (!strcmp(flags, "static"))
 			*mode_flags |= MPOL_F_STATIC_NODES;
-		if (!strcmp(flags, "relative"))
+		else if (!strcmp(flags, "relative"))
 			*mode_flags |= MPOL_F_RELATIVE_NODES;
