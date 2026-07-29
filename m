Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D532D780C
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298538; cv=none; b=Jhf5mR17zLoSBsO32rUZZJz07Kc98QO2iYPVxKnnFOHg+i2SLfL8KrDogU5QZGYZB1KOGc/+5qo4aw3K5xtj3AOPm4MmIQbZQzf150Vdd6cGn0c5T1/E7wMiHeeFfgTDVU0dfruLNArUH/ol4lnRd+KoSWbocGMmbmLhKJYRzY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298538; c=relaxed/simple;
	bh=YAFQnkGeupP/Nf/U6sMYOLC1Wgnnacj8k6VvGKI3yBc=;
	h=Date:To:From:Subject:Message-Id; b=BDY/sNjsEZe2iq+Bc3+JFmdKRj7qm69n343x6yRmci+e5L64pWcBaXswDqL/im3mNJLweernh1zhb6aTWGYD4qAVTXChV1YglnpyLlAzFxJhu6akTMk0hohVMEdvgYWdYNUKcl6nhni7oOmplsanz63MQKDMpx7GEHgy6yjqxso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tvfhotpc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tvfhotpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBADE1F00A3D;
	Wed, 29 Jul 2026 04:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298537;
	bh=xooR41B71/BQmby4/o56bw6Aoaz3lUP2GGhho2MpeVw=;
	h=Date:To:From:Subject;
	b=Tvfhotpcdtluj9vSxy+8js64Ykb9UjtJWHe8Ps+QHpuguYOkdINfv4fA9hcjj6NDZ
	 QutFbpcvsH1A7HW48IAU7aa4cHuVF3WplF8V3fCyt7uofiw5VuzG8+9xvKQbMr4Kec
	 CJ7uDpOBFyXLRO3K4BRni+3FkBQrUzxJUxl6nXhE=
Date: Tue, 28 Jul 2026 21:15:36 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,niecheng1@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-validate-memcg_path-staging-readback.patch removed from -mm tree
Message-Id: <20260729041536.DBADE1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: validate memcg_path staging readback
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-validate-memcg_path-staging-readback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


