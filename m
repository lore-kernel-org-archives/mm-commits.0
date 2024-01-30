Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7AE39879
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597179; cv=none; b=AaTZ7IKgKIizscDi3gz2mBQ+qFVKEw1NH606HWKbq8eHfBP7Glk4e5VOS/fqfUmVZ9SpwQie7DCo/+c3SHXtkIme5dCf+bm94qyD1bKLQJEUHOUQK+zVhQIH6T59b/EQUSqh/H3MbINnt/iaExO0Aho0fxNrC5VKjOYzO/72wAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597179; c=relaxed/simple;
	bh=Tf7R/7l7HTrRvgiFvUViLxgwBvKxutlYON6gQebzQvg=;
	h=Date:To:From:Subject:Message-Id; b=IDZQhf6xG1YXHmkPvipejT5uoZ/y0XGiTUfL9KrF6agnWJib5QDThYxbfPaLLVQgPRGju8AQw/JQxmR63ElWLRV7OhCfJhzq9FWnteObW4OiMxqPlHdycwXl8i+tvuPiyWTnY3e0qXR4SsRWULClt2f8F2i9ryCsaBlYICjbDmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gcy8e5GF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gcy8e5GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBABC433F1;
	Tue, 30 Jan 2024 06:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597179;
	bh=Tf7R/7l7HTrRvgiFvUViLxgwBvKxutlYON6gQebzQvg=;
	h=Date:To:From:Subject:From;
	b=gcy8e5GFQ4XyHRx9FcTxENDaNkBkg6mC24tP+4tucb1vKQDUZ67cAVu98Sk8P53XB
	 6fTUmXs1XzePeSabFJkWx9hIFU9HHg9CVeur9ShpqkPmSW3T0bmCE2IzZfswaqeFW8
	 YmVP27W4iNgS8WoIJOOjN0brc8zsQke5/mOLrZ0g=
Date: Mon, 29 Jan 2024 22:46:06 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-translations-damon-usage-update-for-monitor_on-renaming.patch added to mm-unstable branch
Message-Id: <20240130064618.3FBABC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/translations/damon/usage: update for monitor_on renaming
has been added to the -mm mm-unstable branch.  Its filename is
     docs-translations-damon-usage-update-for-monitor_on-renaming.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-translations-damon-usage-update-for-monitor_on-renaming.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/translations/damon/usage: update for monitor_on renaming
Date: Mon, 29 Jan 2024 17:35:48 -0800

Update DAMON debugfs interface sections on the translated usage documents
to reflect the fact that 'monitor_on' file has renamed to
'monitor_on_DEPRECATED'.

Link: https://lkml.kernel.org/r/20240130013549.89538-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/translations/zh_CN/admin-guide/mm/damon/usage.rst |   20 +++++-----
 Documentation/translations/zh_TW/admin-guide/mm/damon/usage.rst |   20 +++++-----
 2 files changed, 20 insertions(+), 20 deletions(-)

--- a/Documentation/translations/zh_CN/admin-guide/mm/damon/usage.rst~docs-translations-damon-usage-update-for-monitor_on-renaming
+++ a/Documentation/translations/zh_CN/admin-guide/mm/damon/usage.rst
@@ -344,7 +344,7 @@ debugfs接口
   :ref:`sysfs接口<sysfs_interface>`。
 
 DAMON导出了八个文件, ``attrs``, ``target_ids``, ``init_regions``,
-``schemes``, ``monitor_on``, ``kdamond_pid``, ``mk_contexts`` 和
+``schemes``, ``monitor_on_DEPRECATED``, ``kdamond_pid``, ``mk_contexts`` 和
 ``rm_contexts`` under its debugfs directory, ``<debugfs>/damon/``.
 
 
@@ -521,15 +521,15 @@ 大于60%，或低于30%，则停止监�
 开关
 ----
 
-除非你明确地启动监测，否则如上所述的文件设置不会产生效果。你可以通过写入和读取 ``monitor_on``
+除非你明确地启动监测，否则如上所述的文件设置不会产生效果。你可以通过写入和读取 ``monitor_on_DEPRECATED``
 文件来启动、停止和检查监测的当前状态。写入 ``on`` 该文件可以启动对有属性的目标的监测。写入
 ``off`` 该文件则停止这些目标。如果每个目标进程被终止，DAMON也会停止。下面的示例命令开启、关
 闭和检查DAMON的状态::
 
     # cd <debugfs>/damon
-    # echo on > monitor_on
-    # echo off > monitor_on
-    # cat monitor_on
+    # echo on > monitor_on_DEPRECATED
+    # echo off > monitor_on_DEPRECATED
+    # cat monitor_on_DEPRECATED
     off
 
 请注意，当监测开启时，你不能写到上述的debugfs文件。如果你在DAMON运行时写到这些文件，将会返
@@ -543,11 +543,11 @@ DAMON通过一个叫做kdamond的内核�
 得该线程的 ``pid`` 。当监测被 ``关闭`` 时，读取该文件不会返回任何信息::
 
     # cd <debugfs>/damon
-    # cat monitor_on
+    # cat monitor_on_DEPRECATED
     off
     # cat kdamond_pid
     none
-    # echo on > monitor_on
+    # echo on > monitor_on_DEPRECATED
     # cat kdamond_pid
     18594
 
@@ -574,7 +574,7 @@ 如果不再需要上下文，你可以�
     # ls foo
     # ls: cannot access 'foo': No such file or directory
 
-注意， ``mk_contexts`` 、 ``rm_contexts`` 和 ``monitor_on`` 文件只在根目录下。
+注意， ``mk_contexts`` 、 ``rm_contexts`` 和 ``monitor_on_DEPRECATED`` 文件只在根目录下。
 
 
 监测结果的监测点
@@ -583,9 +583,9 @@ 监测结果的监测点
 DAMON通过一个tracepoint ``damon:damon_aggregated`` 提供监测结果.  当监测开启时，你可
 以记录追踪点事件，并使用追踪点支持工具如perf显示结果。比如说::
 
-    # echo on > monitor_on
+    # echo on > monitor_on_DEPRECATED
     # perf record -e damon:damon_aggregated &
     # sleep 5
     # kill 9 $(pidof perf)
-    # echo off > monitor_on
+    # echo off > monitor_on_DEPRECATED
     # perf script
--- a/Documentation/translations/zh_TW/admin-guide/mm/damon/usage.rst~docs-translations-damon-usage-update-for-monitor_on-renaming
+++ a/Documentation/translations/zh_TW/admin-guide/mm/damon/usage.rst
@@ -344,7 +344,7 @@ debugfs接口
   :ref:`sysfs接口<sysfs_interface>`。
 
 DAMON導出了八個文件, ``attrs``, ``target_ids``, ``init_regions``,
-``schemes``, ``monitor_on``, ``kdamond_pid``, ``mk_contexts`` 和
+``schemes``, ``monitor_on_DEPRECATED``, ``kdamond_pid``, ``mk_contexts`` 和
 ``rm_contexts`` under its debugfs directory, ``<debugfs>/damon/``.
 
 
@@ -521,15 +521,15 @@ 大於60%，或低於30%，則停止監�
 開關
 ----
 
-除非你明確地啓動監測，否則如上所述的文件設置不會產生效果。你可以通過寫入和讀取 ``monitor_on``
+除非你明確地啓動監測，否則如上所述的文件設置不會產生效果。你可以通過寫入和讀取 ``monitor_on_DEPRECATED``
 文件來啓動、停止和檢查監測的當前狀態。寫入 ``on`` 該文件可以啓動對有屬性的目標的監測。寫入
 ``off`` 該文件則停止這些目標。如果每個目標進程被終止，DAMON也會停止。下面的示例命令開啓、關
 閉和檢查DAMON的狀態::
 
     # cd <debugfs>/damon
-    # echo on > monitor_on
-    # echo off > monitor_on
-    # cat monitor_on
+    # echo on > monitor_on_DEPRECATED
+    # echo off > monitor_on_DEPRECATED
+    # cat monitor_on_DEPRECATED
     off
 
 請注意，當監測開啓時，你不能寫到上述的debugfs文件。如果你在DAMON運行時寫到這些文件，將會返
@@ -543,11 +543,11 @@ DAMON通過一個叫做kdamond的內核�
 得該線程的 ``pid`` 。當監測被 ``關閉`` 時，讀取該文件不會返回任何信息::
 
     # cd <debugfs>/damon
-    # cat monitor_on
+    # cat monitor_on_DEPRECATED
     off
     # cat kdamond_pid
     none
-    # echo on > monitor_on
+    # echo on > monitor_on_DEPRECATED
     # cat kdamond_pid
     18594
 
@@ -574,7 +574,7 @@ 如果不再需要上下文，你可以�
     # ls foo
     # ls: cannot access 'foo': No such file or directory
 
-注意， ``mk_contexts`` 、 ``rm_contexts`` 和 ``monitor_on`` 文件只在根目錄下。
+注意， ``mk_contexts`` 、 ``rm_contexts`` 和 ``monitor_on_DEPRECATED`` 文件只在根目錄下。
 
 
 監測結果的監測點
@@ -583,10 +583,10 @@ 監測結果的監測點
 DAMON通過一個tracepoint ``damon:damon_aggregated`` 提供監測結果.  當監測開啓時，你可
 以記錄追蹤點事件，並使用追蹤點支持工具如perf顯示結果。比如說::
 
-    # echo on > monitor_on
+    # echo on > monitor_on_DEPRECATED
     # perf record -e damon:damon_aggregated &
     # sleep 5
     # kill 9 $(pidof perf)
-    # echo off > monitor_on
+    # echo off > monitor_on_DEPRECATED
     # perf script
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch

