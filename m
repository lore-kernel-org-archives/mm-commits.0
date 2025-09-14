Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25DA145329
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810137; cv=none; b=UQg0V10L4zQ1xxpyG0Enp+uS0QX9HvDFChzoAqI5zRv7OwI9RtESkNbGtzf1q8ZATuI23J/AxLMCMdhiZgDBpi0RiEkrEx7lM/YbCBZBhdQfTEUOxonoSzev2tjfcvinJDRxA84S4i+HXKMDwr3z7p/uDMdNaMIml+Lr7vE0LMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810137; c=relaxed/simple;
	bh=B5vuIjuFKHQmkMLqEJBCSJC9Tag1MtE5ZKqXhEhOV+4=;
	h=Date:To:From:Subject:Message-Id; b=Ffzt4FsM2aAKqD+Bw5GoYofz64KafsVj6QzDYPRCzOrRZ4AMw9Ly64J3KDOde9mTfil9kvppMuwlNTYjjURlWaBehirBiXl2/EMmoUMDhQI2JApQKjM+GCQ9V2CtIr/Yk6ujohKg92IW7EO6j2D9ENOCbw8gTYrIQc6/rDdd3rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BlXAFR3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BlXAFR3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904EAC4CEEB;
	Sun, 14 Sep 2025 00:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810137;
	bh=B5vuIjuFKHQmkMLqEJBCSJC9Tag1MtE5ZKqXhEhOV+4=;
	h=Date:To:From:Subject:From;
	b=BlXAFR3ZPFyJsB3X7eK909ymC3K5JxspnrqpgtIYJW+jPVuM/IIIdagAROVFVXqS/
	 AsAviSjA85G6WksVtZ0zkDmxueJjEgJT4DUWk68If3UCpHKnwzqYkf4iajd/6DpehX
	 ZcG4CcOAay1ruA07R/erqVrZX3b86EjUfN+TBjO0=
Date: Sat, 13 Sep 2025 17:35:37 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,yangyicong@hisilicon.com,ville.syrjala@linux.intel.com,vgoyal@redhat.com,tzimmermann@suse.de,tony.luck@intel.com,tj@kernel.org,thorsten.blum@linux.dev,tglx@linutronix.de,sohil.mehta@intel.com,senozhatsky@chromium.org,rostedt@goodmis.org,pmladek@suse.com,oushixiong@kylinos.cn,namcao@linutronix.de,mingo@kernel.org,max.kellermann@ionos.com,luogengkun@huaweicloud.com,lihuafei1@huawei.com,kees@kernel.org,Jonathan.Cameron@huawei.com,john.ogness@linutronix.de,joel.granados@kernel.org,jgg@ziepe.ca,gpiccoli@igalia.com,dyoung@redhat.com,djwong@kernel.org,dianders@chromium.org,deller@gmx.de,cuiyunhui@bytedance.com,bhe@redhat.com,anna.schumaker@oracle.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fbdev-use-panic_in_progress-helper.patch removed from -mm tree
Message-Id: <20250914003537.904EAC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fbdev: use panic_in_progress() helper
has been removed from the -mm tree.  Its filename was
     fbdev-use-panic_in_progress-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


