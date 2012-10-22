From: akpm@linux-foundation.org
Subject: + device_cgroup-stop-using-simple_strtoul.patch added to -mm tree
Date: Mon, 22 Oct 2012 12:55:11 -0700
Message-ID: <20121022195512.2F2651E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:63526 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab2JVTzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 15:55:13 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so223938yen.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 12:55:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aris@redhat.com, davej@redhat.com, jmorris@namei.org, jslaby@suse.cz, lizefan@huawei.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@openvz.org


The patch titled
     Subject: device_cgroup: stop using simple_strtoul()
has been added to the -mm tree.  Its filename is
     device_cgroup-stop-using-simple_strtoul.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aristeu Rozanski <aris@redhat.com>
Subject: device_cgroup: stop using simple_strtoul()

Convert the code to use kstrtou32() instead of simple_strtoul() which is
deprecated.  The real size of the variables are u32, so use kstrtou32
instead of kstrtoul

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff -puN security/device_cgroup.c~device_cgroup-stop-using-simple_strtoul security/device_cgroup.c
--- a/security/device_cgroup.c~device_cgroup-stop-using-simple_strtoul
+++ a/security/device_cgroup.c
@@ -361,8 +361,8 @@ static int devcgroup_update_access(struc
 				   int filetype, const char *buffer)
 {
 	const char *b;
-	char *endp;
-	int count;
+	char temp[12];		/* 11 + 1 characters needed for a u32 */
+	int count, rc;
 	struct dev_exception_item ex;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -405,8 +405,16 @@ static int devcgroup_update_access(struc
 		ex.major = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		ex.major = simple_strtoul(b, &endp, 10);
-		b = endp;
+		memset(temp, 0, sizeof(temp));
+		for (count = 0; count < sizeof(temp) - 1; count++) {
+			temp[count] = *b;
+			b++;
+			if (!isdigit(*b))
+				break;
+		}
+		rc = kstrtou32(temp, 10, &ex.major);
+		if (rc)
+			return -EINVAL;
 	} else {
 		return -EINVAL;
 	}
@@ -419,8 +427,16 @@ static int devcgroup_update_access(struc
 		ex.minor = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		ex.minor = simple_strtoul(b, &endp, 10);
-		b = endp;
+		memset(temp, 0, sizeof(temp));
+		for (count = 0; count < sizeof(temp) - 1; count++) {
+			temp[count] = *b;
+			b++;
+			if (!isdigit(*b))
+				break;
+		}
+		rc = kstrtou32(temp, 10, &ex.minor);
+		if (rc)
+			return -EINVAL;
 	} else {
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from aris@redhat.com are

device_cgroup-rename-deny_all-to-behavior.patch
device_cgroup-stop-using-simple_strtoul.patch
device_cgroup-add-proper-checking-when-changing-default-behavior.patch
linux-next.patch

