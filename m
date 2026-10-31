Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793405190;
	b=j+3ziaP9yd3DFHhWodIs2V4lIOeZQg8pYN+aOU3DGq0KONmcCr8qgxS/exIGX4UzOsud
	 a/wuK7/R29mL0nLAMmjUKczT592x3hgXcbYg5TD3U17I0N7pWNnzwUomJg2hhLu9eq/Dt
	 pGCYIq4sMzYTpEY0jh1vSdopXim+S8U2en6iX47pfsJ1TbJJG7+5rw9AfRtvX7hw1/Pg2
	 KyIQKwFGtrGOpgDF1UKMDznKNjyxuS5K12/3Pb7UIDf6RlGLgrkuytW7m3xnQVzjv3C0d
	 8XGBKGNGJX+/9xHRO5rIX9ycnsvAVRXB/0IbPs1xg95vVAsnJY8gpwnJb+xUWqAGgIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793405190;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ohloQ+Z05VP4ThDJzzNJRB7GlZ23h2sTe4b3eBy4EBg=;
	b=sb8UxpX5V/e+CNZYbwgZUC4hzuiquELGpmr28q88b3cbbDQHnwrVQkd5OLA8EEGjHW6w
	 6fvkheMIyF5amJ3RH2hURmDn7AveeXj3VnSC0uksZwsuPHj2X0P6cBMGalUhXJmQASSua
	 VED7O028rNylH5Gj/LpQglhAnRzaUpkinsMY6ry7c+bKtROTP59PxH3IAsQfl09O8MSIx
	 N4bjmpG+3evBkn6QtII3uk2kPuIu4H/Pu9xJDz26Wktt7hhPWLQpEg+mKC2ZglVIcDtiK
	 1cUO4VqJ4h4lFjyn6VkHo7YWBtou6N9KRu57EB/yPtH3YjE51SjGwiBlifZqayxyGoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Cnhu5MWC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC1C606A31A;
	Sat, 31 Oct 2026 00:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Cnhu5MWC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB261F000C1;
	Sat, 31 Oct 2026 00:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793405189;
	bh=ohloQ+Z05VP4ThDJzzNJRB7GlZ23h2sTe4b3eBy4EBg=;
	h=Date:To:From:Subject;
	b=Cnhu5MWC4pYitIe255Q0QUXhO1aNE8CD0N/cZDOG6+NfMpaYT2m1BNCHWAuJ2Klfk
	 M2gk7uZuXSiJlT/YQ56v2MUMLNzl2zSgOrH4TUdyYo3wjNrnzypnUwobfrZV7TcCWx
	 RBP9V3c8ThOgX7D16DOHDzJR2/+Y5FkRMdrxObKw=
Date: Fri, 30 Oct 2026 17:06:29 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,neil@brown.name,
	maarseveent@gmail.com,jlayton@kernel.org,jack@suse.cz,brauner@kernel.org,
	jain.sm@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + errseq-dont-let-errseq_check_and_advance-hide-later-errors.patch added to mm-nonmm-unstable branch
Message-Id: <20261031000629.AFB261F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: errseq: don't let errseq_check_and_advance() hide later errors
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     errseq-dont-let-errseq_check_and_advance-hide-later-errors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/errseq-dont-let-errseq_check_and_advance-hide-later-errors.patch

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
From: Shashank Mohan Jain <jain.sm@gmail.com>
Subject: errseq: don't let errseq_check_and_advance() hide later errors
Date: Sun, 27 Sep 2026 10:47:25 +0530

Patch series "errseq: fix lost writeback errors in
errseq_check_and_advance()".

errseq_check_and_advance() advances the caller's cursor to the value it
tried to store even when its cmpxchg() failed.  If errseq_set() stored a
different errno in the meantime, the cursor holds a value that was never
in the errseq_t.  errseq_set() does not bump the counter while the current
error is unseen, so recording the first errno again recreates exactly that
value, and once another subscriber has marked it seen, the cursor's next
check returns 0.  For fsync() (file->f_wb_err) and syncfs() (sb->s_wb_err)
this means that a writeback error recorded after the previous call
returned is not reported.  The race is rare: it needs two different
errnos, an error recorded while the check runs, and a second subscriber
consuming the value.  There is no user report; it was found with a model
checker.

Patch 1 retries with the value found when the cmpxchg() fails, so the
cursor is only ever advanced to a value that was stored with ERRSEQ_SEEN
set.  Patch 2 adds a KUnit case that races errseq_set() against
errseq_check_and_advance() on two CPUs.

Two behaviour changes are visible to callers, both intended.  When a
writer wins the race, the call now returns the newer errno (still "the
latest error", as documented).  And when two threads race on the same
unserialised cursor (syncfs() does not lock f_sb_err), the loser may now
return 0 where both used to return the error, so each open file
description gets one report.

Dependencies: patch 1 applies to mainline (fd179f8a05be) on its own and
carries Cc: stable.  Patch 2 extends the errseq KUnit suite from commit
b52f5c1605f2 ("lib/tests: add KUnit tests for errseq"), which is only in
mm-nonmm-unstable, so the series is based on mm-nonmm-unstable
(e8d6475e77a7).  Patch 1 could go through mm-hotfixes and patch 2 through
mm-nonmm-unstable.

The bug was found with a TLA+ model of lib/errseq.c checked with TLC.
The patches were prepared with Claude Code (Anthropic), model Claude
Opus 5.5 (claude-opus-5-5).  Testing is described at the Link:.


This patch (of 2):

errseq_check_and_advance() reads the errseq_t, sets ERRSEQ_SEEN with a
cmpxchg() and then advances *since to the value it computed, ignoring
whether the cmpxchg() succeeded. When it fails because errseq_set()
recorded a different error in the meantime, *since ends up holding a
value that was never stored in the errseq_t.

errseq_set() only bumps the counter when ERRSEQ_SEEN is set. So as long
as nobody has seen the new error, recording the original errno again
recreates exactly the old value, and once another subscriber marks it
seen, it is equal to the stale *since. The next check through that
cursor then reports nothing, although -ENOSPC was recorded after the
value that check reported, and -EIO was recorded again after it
returned:

  cursor f                writeback              cursor g
  --------                ---------              --------
                          set(-EIO)
  check_and_advance(&f)
    old = [c, EIO]
                          set(-ENOSPC)
                          -> [c, ENOSPC]
    cmpxchg() fails
    f = [c, EIO, SEEN]
    returns -EIO
                          set(-EIO)
                          -> [c, EIO]
                          (no bump: unseen)
                                                 check_and_advance(&g)
                                                 -> [c, EIO, SEEN]
                                                 returns -EIO
  check_and_advance(&f)
    [c, EIO, SEEN] == f
    returns 0             <- -ENOSPC and the second -EIO are lost

For file->f_wb_err this means that fsync() on one descriptor can return 0
although writeback failed after the previous fsync() on that descriptor
returned, when writeback errors race with fsync() on another descriptor of
the same file.  The same applies to syncfs() through sb->s_wb_err, which
every file on the filesystem shares, and to the ext4 and jbd2 cursors on
the block device mapping.  The kernel-doc promises "Negative errno if one
has been stored, or 0 if no new error has occurred".

Retry with the value found when the cmpxchg() fails, so that *since is
only ever advanced to a value that was actually stored with ERRSEQ_SEEN
set.  Every later errseq_set() then has to bump the counter, and the error
is reported.  The retry loop terminates because each iteration needs a
concurrent update, like the loop in errseq_set().

A TLA+ model of errseq_set() and errseq_check_and_advance(), checked with
the TLC model checker, finds the lost error with the current code; with
this change TLC checks that an error recorded after a check returned is
always reported by the next check (exhaustively for two subscribers with
three checks each, and one writer recording four errors or two writers
recording two each).  The KUnit race test added in the next patch misses
the error in 1-6% of 2 million rounds on 4-CPU UML before this change
(depending on host load), and in none after it.

Link: https://lore.kernel.org/20260927051726.71337-1-jain.sm@gmail.com
Link: https://lore.kernel.org/20260927051726.71337-2-jain.sm@gmail.com
Fixes: 84cbadadc6ea ("lib: add errseq_t type and infrastructure for handling it")
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>
Cc: Thomas Maarseveen <maarseveent@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
---

 lib/errseq.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/lib/errseq.c~errseq-dont-let-errseq_check_and_advance-hide-later-errors
+++ a/lib/errseq.c
@@ -162,7 +162,8 @@ EXPORT_SYMBOL(errseq_check);
  * points to. If it does, then just return 0.
  *
  * If it doesn't, then the value has changed. Set the "seen" flag, and try to
- * swap it into place as the new eseq value. Then, set that value as the new
+ * swap it into place as the new eseq value. If the swap fails because the
+ * value changed, retry with the new value. Then, set that value as the new
  * "since" value, and return whatever the error portion is set to.
  *
  * Note that no locking is provided here for concurrent updates to the "since"
@@ -184,24 +185,30 @@ int errseq_check_and_advance(errseq_t *e
 	 * to take the lock that protects the "since" value.
 	 */
 	old = READ_ONCE(*eseq);
-	if (old != *since) {
+	while (old != *since) {
 		/*
 		 * Set the flag and try to swap it into place if it has
 		 * changed.
 		 *
-		 * We don't care about the outcome of the swap here. If the
-		 * swap doesn't occur, then it has either been updated by a
-		 * writer who is altering the value in some way (updating
-		 * counter or resetting the error), or another reader who is
-		 * just setting the "seen" flag. Either outcome is OK, and we
-		 * can advance "since" and return an error based on what we
-		 * have.
+		 * If the swap fails, a writer or another reader changed the
+		 * value under us, so retry with the new value.  "since" must
+		 * only ever be set to a value that was stored with the SEEN
+		 * flag: errseq_set() does not bump the counter while the
+		 * flag is clear, so an unstored value could come back later
+		 * and hide the errors that were recorded in the meantime.
 		 */
 		new = old | ERRSEQ_SEEN;
-		if (new != old)
-			cmpxchg(eseq, old, new);
+		if (new != old) {
+			errseq_t cur = cmpxchg(eseq, old, new);
+
+			if (cur != old) {
+				old = cur;
+				continue;
+			}
+		}
 		*since = new;
 		err = -(new & ERRNO_MASK);
+		break;
 	}
 	return err;
 }
_

Patches currently in -mm which might be from jain.sm@gmail.com are

errseq-dont-let-errseq_check_and_advance-hide-later-errors.patch
lib-tests-errseq-add-a-concurrent-check_and_advance-test.patch

