From: akpm@linux-foundation.org
Subject: [patch 108/126] test_kmod: remove paranoid UINT_MAX check
 on uint range processing
Date: Fri, 08 Sep 2017 16:16:53 -0700
Message-ID: <20170908231653.USWVMGsZJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53504 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932381AbdIHXQz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:16:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, colin.king@canonical.com, dan.carpenter@oracle.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, mbenes@suse.cz, mcgrof@kernel.org, mm-commits@vger.kernel.org, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org, torvalds@linux-foundation.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: test_kmod: remove paranoid UINT_MAX check on uint range processing

The UINT_MAX comparison is not needed because "max" is already an unsigned
int, and we expect developer C code max value input to have a sensible 0 -
UINT_MAX range.  Note that if it so happens to be UINT_MAX + 1 it would
lead to an issue, but we expect the developer to know this.

[mcgrof@kernel.org: massaged commit log]
Link: http://lkml.kernel.org/r/20170802211707.28020-2-mcgrof@kernel.org
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

diff -puN lib/test_kmod.c~test_kmod-remove-paranoid-uint_max-check-on-uint-range-processing lib/test_kmod.c
--- a/lib/test_kmod.c~test_kmod-remove-paranoid-uint_max-check-on-uint-range-processing
+++ a/lib/test_kmod.c
@@ -924,7 +924,7 @@ static int test_dev_config_update_uint_r
 	if (ret)
 		return ret;
 
-	if (new < min || new >  max || new > UINT_MAX)
+	if (new < min || new > max)
 		return -EINVAL;
 
 	mutex_lock(&test_dev->config_mutex);
_
