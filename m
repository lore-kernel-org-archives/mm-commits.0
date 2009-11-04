From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: vga_arb warning [was: mmotm 2009-11-01-10-01 uploaded]
Date: Tue, 3 Nov 2009 21:48:45 -0800
Message-ID: <20091103214845.9660895d.akpm@linux-foundation.org>
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org>
	<4AEE01D9.8040902@gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbZKDFtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Nov 2009 00:49:07 -0500
In-Reply-To: <4AEE01D9.8040902@gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Tiago Vignatti <tiago.vignatti@nokia.com>, Dave Airlie <airlied@redhat.com>, kvm@vger.kernel.org, Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>


Please cc me on mmotm bug reports!

On Sun, 01 Nov 2009 22:47:05 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:

> On 11/01/2009 07:07 PM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-11-01-10-01 has been uploaded to
> 
> Hi, I got the following warning while booting an image in qemu-kvm:
> 
> WARNING: at fs/attr.c:158 notify_change+0x2da/0x310()
> Hardware name:
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.32-rc5-mm1_64 #862
> Call Trace:
>  [<ffffffff81038008>] warn_slowpath_common+0x78/0xb0
>  [<ffffffff8103804f>] warn_slowpath_null+0xf/0x20
>  [<ffffffff810d32ba>] notify_change+0x2da/0x310
>  [<ffffffff810c5b88>] ? fsnotify_create+0x48/0x60
>  [<ffffffff810c6d2b>] ? vfs_mknod+0xbb/0xe0
>  [<ffffffff812487b6>] devtmpfs_create_node+0x1e6/0x270
>  [<ffffffff811170d0>] ? sysfs_addrm_finish+0x20/0x280
>  [<ffffffff811175d6>] ? __sysfs_add_one+0x26/0xf0
>  [<ffffffff81117b6c>] ? sysfs_do_create_link+0xcc/0x160
>  [<ffffffff81241cf0>] device_add+0x1e0/0x5b0
>  [<ffffffff8124adb1>] ? pm_runtime_init+0xa1/0xb0
>  [<ffffffff81248f05>] ? device_pm_init+0x65/0x70
>  [<ffffffff812420d9>] device_register+0x19/0x20
>  [<ffffffff81242290>] device_create_vargs+0xf0/0x120
>  [<ffffffff812422ec>] device_create+0x2c/0x30
>  [<ffffffff810c0516>] ? __register_chrdev+0x86/0xf0
>  [<ffffffff81245599>] ? __class_create+0x69/0xa0
>  [<ffffffff814326e9>] ? mutex_lock+0x19/0x50
>  [<ffffffff811d4e23>] misc_register+0x93/0x170
>  [<ffffffff818994a0>] ? vga_arb_device_init+0x0/0x77
>  [<ffffffff818994b3>] vga_arb_device_init+0x13/0x77
>  [<ffffffff818994a0>] ? vga_arb_device_init+0x0/0x77
>  [<ffffffff810001e7>] do_one_initcall+0x37/0x190
>  [<ffffffff8187d6ce>] kernel_init+0x172/0x1c8
>  [<ffffffff81003c7a>] child_rip+0xa/0x20
>  [<ffffffff8187d55c>] ? kernel_init+0x0/0x1c8
>  [<ffffffff81003c70>] ? child_rip+0x0/0x20

There's a -mm-only debug patch:

http://userweb.kernel.org/~akpm/mmotm/broken-out/notify_change-callers-must-hold-i_mutex.patch

--- a/fs/attr.c~notify_change-callers-must-hold-i_mutex
+++ a/fs/attr.c
@@ -155,6 +155,8 @@ int notify_change(struct dentry * dentry
 			return -EPERM;
 	}
 
+	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
+
 	now = current_fs_time(inode->i_sb);
 
 	attr->ia_ctime = now;
_

I forget why it was added.


It looks like it's blaming the open-coded notify_change() call in
devtmpfs_create_node().

