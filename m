Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CCD2A1BF
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 00:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756167985; cv=none; b=mWVSNWKpssTDTrmG3rSX+P5YLYcGX13XS/Ha6nEEBI4FKm0BdQzucnBWgj40FYF1NCnUV21J31ZLvR3THL15E8GNdZ7yV6N9s61X2l/YeRp4zB3l8qVwlDEfUoWCowmuQcdxDPSoKcQPzFduCrvphSaGj4qfB0lg8adiiZk1o6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756167985; c=relaxed/simple;
	bh=PZmtg1Prv3BKUI6O/zd9Ki/tNKi9+tDbIfuMLJKNPuA=;
	h=Date:To:From:Subject:Message-Id; b=STYX+NYvlnEjExAlkloQfCFZsLxrS01YDZ+uisC2WqBWKlGp4cTDNFuMeB8aAQYeRJaQFOdlULx3jBFpP22yzyyJ9Gk0H5aLGoEOi+SKQ4HHtmLn9w+qQBll+hDJdhUMLv7RKKJFH+RzZLxmNFYgLMbh3y+VHuXH3nRiNHmLCEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JpeWMgIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JpeWMgIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62315C4CEED;
	Tue, 26 Aug 2025 00:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756167985;
	bh=PZmtg1Prv3BKUI6O/zd9Ki/tNKi9+tDbIfuMLJKNPuA=;
	h=Date:To:From:Subject:From;
	b=JpeWMgIbpPsR9oQ7a4AIDVcIeT+clp7b9LfRWyWR79JAWTXHnH2qhhje6IsmkiIgq
	 ipHPEOg8YrIKNKVyzO6hwyJWTgb9Nm0GXnVEn2WmqcNkDpmVIg2xBQDjcGrbYdH/S3
	 wGq/91tw2EcnGPbaz9WKxIeXprbk70S/I2pWc+T8=
Date: Mon, 25 Aug 2025 17:26:24 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,yangyicong@hisilicon.com,ville.syrjala@linux.intel.com,vgoyal@redhat.com,tzimmermann@suse.de,tony.luck@intel.com,tj@kernel.org,thorsten.blum@linux.dev,tglx@linutronix.de,sohil.mehta@intel.com,senozhatsky@chromium.org,rostedt@goodmis.org,pmladek@suse.com,oushixiong@kylinos.cn,namcao@linutronix.de,mingo@kernel.org,max.kellermann@ionos.com,luogengkun@huaweicloud.com,lihuafei1@huawei.com,kees@kernel.org,Jonathan.Cameron@huawei.com,john.ogness@linutronix.de,joel.granados@kernel.org,jgg@ziepe.ca,gpiccoli@igalia.com,dyoung@redhat.com,djwong@kernel.org,dianders@chromium.org,deller@gmx.de,cuiyunhui@bytedance.com,bhe@redhat.com,anna.schumaker@oracle.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fbdev-use-panic_in_progress-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20250826002625.62315C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fbdev: use panic_in_progress() helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fbdev-use-panic_in_progress-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fbdev-use-panic_in_progress-helper.patch

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
From: Jinchao Wang <wangjinchao600@gmail.com>
Subject: fbdev: use panic_in_progress() helper
Date: Mon, 25 Aug 2025 10:29:30 +0800

Update the fbcon_skip_panic() function to use the panic_in_progress()
helper.

The previous direct access to panic_cpu is less readable and is being
replaced by a dedicated function that more clearly expresses the intent.

This change is part of a series to refactor the kernel's panic handling
logic for better clarity and robustness.

Link: https://lkml.kernel.org/r/20250825022947.1596226-3-wangjinchao600@gmail.com
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Acked-by Qianqiang Liu <qianqiang.liu@163.com>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Kees Cook <kees@kernel.org>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Luo Gengkun <luogengkun@huaweicloud.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: oushixiong <oushixiong@kylinos.cn>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/core/fbcon.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c~fbdev-use-panic_in_progress-helper
+++ a/drivers/video/fbdev/core/fbcon.c
@@ -279,14 +279,7 @@ static int fbcon_get_rotate(struct fb_in
 
 static bool fbcon_skip_panic(struct fb_info *info)
 {
-/* panic_cpu is not exported, and can't be used if built as module. Use
- * oops_in_progress instead, but non-fatal oops won't be printed.
- */
-#if defined(MODULE)
-	return (info->skip_panic && unlikely(oops_in_progress));
-#else
-	return (info->skip_panic && unlikely(atomic_read(&panic_cpu) != PANIC_CPU_INVALID));
-#endif
+	return (info->skip_panic && unlikely(panic_in_progress()));
 }
 
 static inline bool fbcon_is_active(struct vc_data *vc, struct fb_info *info)
_

Patches currently in -mm which might be from wangjinchao600@gmail.com are

panic-introduce-helper-functions-for-panic-state.patch
fbdev-use-panic_in_progress-helper.patch
crash_core-use-panic_try_start-in-crash_kexec.patch
panic-use-panic_try_start-in-nmi_panic.patch
panic-use-panic_try_start-in-vpanic.patch
printk-nbcon-use-panic_on_this_cpu-helper.patch
panic-printk-replace-this_cpu_in_panic-with-panic_on_this_cpu.patch
panic-printk-replace-other_cpu_in_panic-with-panic_on_other_cpu.patch
watchdog-skip-checks-when-panic-is-in-progress.patch

