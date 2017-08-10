From: akpm@linux-foundation.org
Subject: [patch 06/21] test_kmod: fix the lock in register_test_dev_kmod()
Date: Thu, 10 Aug 2017 15:23:47 -0700
Message-ID: <598cdcf3.RHb4VgFl6XwbgKXW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753367AbdHJWXs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dan.carpenter@oracle.com, colin.king@canonical.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, mbenes@suse.cz, mcgrof@kernel.org, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: test_kmod: fix the lock in register_test_dev_kmod()

We accidentally just drop the lock twice instead of taking it and then
releasing it.  This isn't a big issue unless you are adding more than one
device to test on, and the kmod.sh doesn't do that yet, however this
obviously is the correct thing to do.

[mcgrof@kernel.org: massaged subject, explain what happens]
Link: http://lkml.kernel.org/r/20170802211450.27928-5-mcgrof@kernel.org
Fixes: 39258f448d71 ("kmod: add test driver to stress test the module loader")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/test_kmod.c~test_kmod-fix-the-lock-in-register_test_dev_kmod lib/test_kmod.c
--- a/lib/test_kmod.c~test_kmod-fix-the-lock-in-register_test_dev_kmod
+++ a/lib/test_kmod.c
@@ -1146,7 +1146,7 @@ static struct kmod_test_device *register
 	struct kmod_test_device *test_dev = NULL;
 	int ret;
 
-	mutex_unlock(&reg_dev_mutex);
+	mutex_lock(&reg_dev_mutex);
 
 	/* int should suffice for number of devices, test for wrap */
 	if (unlikely(num_test_devs + 1) < 0) {
_
