From: akpm@linux-foundation.org
Subject: +
 configfs-fix-kernel-infoleak-through-user-controlled-format-string.patch
 added to -mm tree
Date: Tue, 07 Jul 2015 14:54:05 -0700
Message-ID: <559c4a7d.hVo6s9AseUV6l6my%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745AbbGGVyG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 17:54:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, balbi@ti.com, gregkh@linuxfoundation.org, jlbec@evilplan.org, mm-commits@vger.kernel.org


The patch titled
     Subject: configfs: fix kernel infoleak through user-controlled format string
has been added to the -mm tree.  Its filename is
     configfs-fix-kernel-infoleak-through-user-controlled-format-string.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/configfs-fix-kernel-infoleak-through-user-controlled-format-string.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/configfs-fix-kernel-infoleak-through-user-controlled-format-string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: configfs: fix kernel infoleak through user-controlled format string

Some modules call config_item_init_type_name() and
config_group_init_type_name() with parameter "name" directly controlled by
userspace.  These two functions call config_item_set_name() with this name
used as a format string, which can be used to leak information such as
content of the stack to userspace.

For example, make_netconsole_target() in netconsole module calls
config_item_init_type_name() with the name of a newly-created directory.
This means that the following commands give some unexpected output, with
configfs mounted in /sys/kernel/config/ and on a system with a
configured eth0 ethernet interface:

    # modprobe netconsole
    # mkdir /sys/kernel/config/netconsole/target_%lx
    # echo eth0 > /sys/kernel/config/netconsole/target_%lx/dev_name
    # echo 1 > /sys/kernel/config/netconsole/target_%lx/enabled
    # echo eth0 > /sys/kernel/config/netconsole/target_%lx/dev_name
    # dmesg |tail -n1
    [  142.697668] netconsole: target (target_ffffffffc0ae8080) is
    enabled, disable to update parameters

The directory name is correct but %lx has been interpreted in the
internal item name, displayed here in the error message used by
store_dev_name() in drivers/net/netconsole.c.

To fix this, update every caller of config_item_set_name to use "%s"
when operating on untrusted input.

This issue was found using -Wformat-security gcc flag, once a __printf
attribute has been added to config_item_set_name().

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/configfs.c |    2 +-
 fs/configfs/item.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/usb/gadget/configfs.c~configfs-fix-kernel-infoleak-through-user-controlled-format-string drivers/usb/gadget/configfs.c
--- a/drivers/usb/gadget/configfs.c~configfs-fix-kernel-infoleak-through-user-controlled-format-string
+++ a/drivers/usb/gadget/configfs.c
@@ -571,7 +571,7 @@ static struct config_group *function_mak
 	if (IS_ERR(fi))
 		return ERR_CAST(fi);
 
-	ret = config_item_set_name(&fi->group.cg_item, name);
+	ret = config_item_set_name(&fi->group.cg_item, "%s", name);
 	if (ret) {
 		usb_put_function_instance(fi);
 		return ERR_PTR(ret);
diff -puN fs/configfs/item.c~configfs-fix-kernel-infoleak-through-user-controlled-format-string fs/configfs/item.c
--- a/fs/configfs/item.c~configfs-fix-kernel-infoleak-through-user-controlled-format-string
+++ a/fs/configfs/item.c
@@ -115,7 +115,7 @@ void config_item_init_type_name(struct c
 				const char *name,
 				struct config_item_type *type)
 {
-	config_item_set_name(item, name);
+	config_item_set_name(item, "%s", name);
 	item->ci_type = type;
 	config_item_init(item);
 }
@@ -124,7 +124,7 @@ EXPORT_SYMBOL(config_item_init_type_name
 void config_group_init_type_name(struct config_group *group, const char *name,
 			 struct config_item_type *type)
 {
-	config_item_set_name(&group->cg_item, name);
+	config_item_set_name(&group->cg_item, "%s", name);
 	group->cg_item.ci_type = type;
 	config_group_init(group);
 }
_

Patches currently in -mm which might be from nicolas.iooss_linux@m4x.org are

include-lib-add-__printf-attributes-to-several-function-prototypes.patch
configfs-fix-kernel-infoleak-through-user-controlled-format-string.patch
linux-next.patch

