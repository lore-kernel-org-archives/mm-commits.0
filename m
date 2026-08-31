Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F44403EA1
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788219115; cv=none; b=F1ZYRHpAUP0jE/YV7tOw/BQ6YIK5YysDn2RaOP7+v3O+dbwAxQQ0CFUYuaZ7dhnMVv2203QGz/v2iveg7WhokOCtSDmFPp9ol0pcW9KcROVEIKu2KyL2/WhEDvPGLTQ/nSLUkGxFQnrgNC4k0P1y5KGUr6jHKg24jSiASXKnBxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788219115; c=relaxed/simple;
	bh=0+cJrB9JfdwHYlYv+DYPJnkuN7ArF8YA2FHbu99CCaQ=;
	h=Date:To:From:Subject:Message-Id; b=PN5+f5nfUSKDwVY7UCFOdMyVOmurmN0WHZ/ajbHuLXP7mBUrU7N2zh9SdaxPkun9yl0qddvV+XGvRbjsWzxprq5IMfhvjHYSZ5wvg5DK7MbhR44dsIKYy1FYxxNxIRSh40uDx/sOH7tl/a9Gcg3Ncex4jzL/M+cfcoiIrzQrHh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZgFQ5c5P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZgFQ5c5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148D41F000E9;
	Mon, 31 Aug 2026 23:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788219114;
	bh=ccCiqLe6OE76dnAlxU+90JVtCX1KQWmwSiMCPTJ7jYA=;
	h=Date:To:From:Subject;
	b=ZgFQ5c5P8DLKux1ta6uFiUHF4b0zCKXlr7E+bHdG+HjSQvOnmcML7W2VJShSapd2D
	 udDs331YNBsBntUVyki23BcjH3Ku2Emoi1xsEI1ShqSEXjgU3cGP/jKJKlqGM/CFHc
	 mQXYY9wNLl8PLbq67YsAK7sgoveJFNLLG4Blnn9M=
Date: Mon, 31 Aug 2026 16:31:53 -0700
To: mm-commits@vger.kernel.org,zhaozhengzhuo@uniontech.com,zenghui.yu@linux.dev,sj@kernel.org,shuah@kernel.org,liyouhong@kylinos.cn,lienze@kylinos.cn,jaeyeon.lee.dev@gmail.com,gregkh@linuxfoundation.org,harimishal1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-clean-up-sh-processes-used-for-obsolete_target-test.patch added to mm-new branch
Message-Id: <20260831233154.148D41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: clean up sh processes used for obsolete_target test
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-clean-up-sh-processes-used-for-obsolete_target-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-clean-up-sh-processes-used-for-obsolete_target-test.patch

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
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Li Youhong <liyouhong@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

selftests-damon-sysfspy-clean-up-sh-processes-used-for-obsolete_target-test.patch

