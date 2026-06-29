Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C202DB798
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782755620; cv=none; b=OgBXuePGyouTckvTyyYm4EQGaVwE8CHTqkPdSfBouCvTzN+wOH0+6cXvv4YWgWTasUD8SQh14XVsLn3oncMywQScqdqNAXfgFvyuiM8+SXQZ9euyelCLqeJVcNzrMkXm3DpRRJXbIvPwUgAlvS7didrKoImdFFK+FI1HOomPoVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782755620; c=relaxed/simple;
	bh=GRMqOvYtYTRKOPc2JhflpfDn+l8pafqtylrMNjFZAfA=;
	h=Date:To:From:Subject:Message-Id; b=LOp6Jc+4qM1Z26ONCVQitOo0aQBD0nE57dT8C9Ojjfz2lDZ+y8hAIVEVTGnnHSSfVJmP9noObKHlMbo40ErVM66/KnNP7OXUrBXFb2JUlFqif8xf9F3rkmF4h1GDjxYoQFqqs0c58cr5gLd0sAyVOIwoZrdFgviBNhMu+UmatyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jIyRQ0LJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jIyRQ0LJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092AF1F000E9;
	Mon, 29 Jun 2026 17:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782755619;
	bh=qb+yVndiKUcckJf5JMGncb0aqxKU6apHnib+9NOz3zY=;
	h=Date:To:From:Subject;
	b=jIyRQ0LJyVE+o8PM92Jti6NCc7Kroy0NBFZjXp7g1TwVrCqjLZB71bcwuW3KrtT+s
	 dKU7BeTvfjy4OzbZa80BSpc5YTPwhKdBCVx4ECcI1dOzgmdEjjhx6nRtVp88tUhXFD
	 X7QUFkwxlGqdpWDfTrlL6tWCU8NTpfBJkb+dSwMs=
Date: Mon, 29 Jun 2026 10:53:38 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,niecheng1@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-validate-memcg_path-staging-readback.patch added to mm-new branch
Message-Id: <20260629175339.092AF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: validate memcg_path staging readback
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-validate-memcg_path-staging-readback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-validate-memcg_path-staging-readback.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Cheng Nie <niecheng1@uniontech.com>
Subject: selftests/damon/sysfs.py: validate memcg_path staging readback
Date: Mon, 29 Jun 2026 07:48:11 -0700

Add a dedicated test at the end of main() that stages memcg_path via sysfs
and verifies its readback.  Configure the memcg filter before start(), do
not call commit(), and ignore start() failures so the test does not depend
on CONFIG_MEMCG or cgroup layout.  Call stop() for cleanup without
checking its return value.

Link: https://lore.kernel.org/D2B37130D38E09AC+20260601090634.241864-1-niecheng1@uniontech.com
Link: https://lore.kernel.org/20260629144812.134159-3-sj@kernel.org
Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   31 +++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-validate-memcg_path-staging-readback
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -250,6 +250,35 @@ def assert_ctxs_committed(kdamonds):
             if ctx in ctxs_paused_for_dump:
                 ctx.pause = False
 
+def test_memcg_filter_memcg_path_staging():
+    global kdamonds
+    memcg_filter = _damon_sysfs.DamosFilter(
+            type_='memcg', matching=True, allow=True, memcg_path='/')
+    kdamonds = _damon_sysfs.Kdamonds(
+            [_damon_sysfs.Kdamond(
+                contexts=[_damon_sysfs.DamonCtx(
+                    targets=[_damon_sysfs.DamonTarget(pid=-1)],
+                    schemes=[_damon_sysfs.Damos(
+                        ops_filters=[memcg_filter])],
+                    )])])
+    kdamonds.start()
+
+    shown, rd_err = _damon_sysfs.read_file(
+            os.path.join(memcg_filter.sysfs_dir(), 'memcg_path'))
+    if rd_err is not None:
+        print('memcg_path staging: sysfs read (%s)' % rd_err)
+        kdamonds.stop()
+        exit(1)
+    if shown.rstrip('\n') != memcg_filter.memcg_path:
+        print('memcg_path staging: memcg_path readback '
+              '(shown=%s, expected=%s)' %
+              (shown.rstrip('\n'), memcg_filter.memcg_path))
+        kdamonds.stop()
+        exit(1)
+
+    kdamonds.stop()
+    kdamonds = None
+
 def main():
     global kdamonds
     kdamonds = _damon_sysfs.Kdamonds(
@@ -356,5 +385,7 @@ def main():
     assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
+    test_memcg_filter_memcg_path_staging()
+
 if __name__ == '__main__':
     main()
_

Patches currently in -mm which might be from niecheng1@uniontech.com are

selftests-damon-_damon_sysfspy-fix-memcg_path-assignment.patch
selftests-damon-sysfspy-validate-memcg_path-staging-readback.patch

