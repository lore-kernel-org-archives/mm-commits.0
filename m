Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6667230C146
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334288; cv=none; b=I/hQl55tfTRuvD3YHqqd391yLiXrwTvdBOEd2Cw7f5dIXlXP30zkv2p1rHsY7hgw3UqEcq8vwQxFZotbozL1+Nfl8E0ZR/CmkuiIkDoYTRYwKo1Hsc/cXwLPYSouFA/1zvYCQKFreRiyls7e2SdgiGQX72kIW6REvHQxywJOB7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334288; c=relaxed/simple;
	bh=a+m5cY5xXdFO+8lqTcZ2eNv0CaUk1YnKLmM2byFC1Ko=;
	h=Date:To:From:Subject:Message-Id; b=E+rF3jK6iAPRlrOy9Au28WrESz0bBMNRRARHi+UJZQqMp1PSW7nhaNV7uxJlDHL9DxeSd+9laGkhVy65HOBC+1d4E1C33z3bwB9LdIcgwd30q+fzwCQ4O3J1VE3x/HbR0mYoC3sGkr6BfvPEyc1G/UK1bxonxGSK9lZoS/uux+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n1liychG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n1liychG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E07C1F0089B;
	Wed,  7 Oct 2026 00:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334287;
	bh=SJqZVJ7FHfW0fmIVY4dVThERN1CD9VjtBLhsmDNW124=;
	h=Date:To:From:Subject;
	b=n1liychGeqa01gsX8LDcXRFXtCfxlvXTIsYda61MdLBhldQreHfuhzbHgPDdy94zQ
	 Pwsmb1xEsmd+V4sUrk+4AsPN5RxGFO5FbMbaRYpVQHIgk99KIG51Bsn/STS9s9n6fn
	 JFRtbDgOD9ly9v5Ne/R9hDvuZo25g1dNIbCuc+5w=
Date: Tue, 06 Oct 2026 17:51:26 -0700
To: mm-commits@vger.kernel.org,zhaozhengzhuo@uniontech.com,zenghui.yu@linux.dev,sj@kernel.org,shuah@kernel.org,liyouhong@kylinos.cn,lienze@kylinos.cn,jaeyeon.lee.dev@gmail.com,gregkh@linuxfoundation.org,harimishal1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-clean-up-sh-processes-used-for-obsolete_target-test.patch removed from -mm tree
Message-Id: <20261007005127.3E07C1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: clean up sh processes used for obsolete_target test
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-clean-up-sh-processes-used-for-obsolete_target-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hari Mishal <harimishal1@gmail.com>
Subject: selftests/damon/sysfs.py: clean up sh processes used for obsolete_target test
Date: Mon, 31 Aug 2026 07:26:06 -0700

The obsolete_target test spawns three sh processes and uses their pids as
DAMON monitoring targets.  These processes are never terminated or waited
on, so they are left running (or become zombies) as orphaned children
after the test program exits.

Terminate each process and communicate() with it after the targets are no
longer needed, so it exits and gets reaped instead of being leaked.

Link: https://lore.kernel.org/20260831142611.77572-5-sj@kernel.org
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Li Youhong <liyouhong@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
---

 tools/testing/selftests/damon/sysfs.py |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-clean-up-sh-processes-used-for-obsolete_target-test
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -385,6 +385,10 @@ def main():
     assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
+    for proc in (proc1, proc2, proc3):
+        proc.terminate()
+        proc.communicate()
+
     test_memcg_filter_memcg_path_staging()
 
 if __name__ == '__main__':
_

Patches currently in -mm which might be from harimishal1@gmail.com are


