From: akpm@linux-foundation.org
Subject: [patch 109/126] test_kmod: flip INT checks to be
 consistent
Date: Fri, 08 Sep 2017 16:16:57 -0700
Message-ID: <20170908231657.mDsJVM2au%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53538 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932381AbdIHXQ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:16:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, colin.king@canonical.com, dan.carpenter@oracle.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, mbenes@suse.cz, mcgrof@kernel.org, mm-commits@vger.kernel.org, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org, torvalds@linux-foundation.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: test_kmod: flip INT checks to be consistent

Most checks will check for min and then max, except the int check.  Flip
the checks to be consistent with the other code.

[mcgrof@kernel.org: massaged commit log]
Link: http://lkml.kernel.org/r/20170802211707.28020-3-mcgrof@kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/test_kmod.c~test_kmod-flip-int-checks-to-be-consistent lib/test_kmod.c
--- a/lib/test_kmod.c~test_kmod-flip-int-checks-to-be-consistent
+++ a/lib/test_kmod.c
@@ -946,7 +946,7 @@ static int test_dev_config_update_int(st
 	if (ret)
 		return ret;
 
-	if (new > INT_MAX || new < INT_MIN)
+	if (new < INT_MIN || new > INT_MAX)
 		return -EINVAL;
 
 	mutex_lock(&test_dev->config_mutex);
_
