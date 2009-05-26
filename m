From: akpm@linux-foundation.org
Subject: [wrecked] inotify-reimplement-inotify-using-fsnotify-report-rounded-up-event-size-to-user-space.patch removed from -mm tree
Date: Tue, 26 May 2009 12:34:52 -0700
Message-ID: <200905261934.n4QJYrQn005877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757556AbZEZTfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:35:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     inotify: report rounded-up event size to user space
has been removed from the -mm tree.  Its filename was
     inotify-reimplement-inotify-using-fsnotify-report-rounded-up-event=
-size-to-user-space.patch

This patch was dropped because other changes were merged, which wrecked=
 this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: inotify: report rounded-up event size to user space
=46rom: Wu Fengguang <fengguang.wu@intel.com>

On Wed, May 06, 2009 at 09:42:58PM +0800, Kay Sievers wrote:
> On Mon, May 4, 2009 at 15:30, Wu Fengguang <fengguang.wu@intel.com> w=
rote:
>
> > I tried remove every udev rules in /etc/udev/ and /lib/udev, the /e=
tc/group
> > accesses disappeared in strace, but udevd is still busy.
>
> > ppoll([{fd=3D4, events=3DPOLLIN}, {fd=3D5, events=3DPOLLIN}, {fd=3D=
3, events=3DPOLLIN}], 3, NULL, [], 8) =3D 1 ([{fd=3D3, revents=3DPOLLIN=
}])
> > ioctl(3, FIONREAD, [39]) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0=3D 0
> > read(3, 0x62ad60, 39) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D -1 EINVAL (Invalid argument)
>
> Seems, you have issues with inotify on your nfs mount?
>
> Inotify wakes up udevd to tell something in the rules directory has
> changed, but inotify seems not to return anything useful, but keeps
> waking us up. That causes an endless loop of parsing rules files.

Thanks for the tip. The failed inotify read() is caused by the size *ro=
undup*
behavior introduced by the -mm commit 3b46cf7d5f3ca(Reimplement inotify=
_user
using fsnotify).  Which says:

+               /*
+                * We need to pad the filename so as to properly align =
an
+                * array of inotify_event structures.  Because the stru=
cture is
+                * small and the common case is a small filename, we ju=
st round
+                * up to the next multiple of the structure's sizeof.  =
This is
+                * simple and safe for all architectures.
+                */

The udev madness originates from these kernel testing failures:

[  756.569243] get_one_event: event_size=3D48 > count=3D38, name_len=3D=
22, name=3D61-dev-root-link.rules
[  756.600103] get_one_event: event_size=3D48 > count=3D38, name_len=3D=
22, name=3D61-dev-root-link.rules
[  756.630265] get_one_event: event_size=3D48 > count=3D38, name_len=3D=
22, name=3D61-dev-root-link.rules
[  756.670862] get_one_event: event_size=3D48 > count=3D38, name_len=3D=
22, name=3D61-dev-root-link.rules
[  756.701845] get_one_event: event_size=3D48 > count=3D38, name_len=3D=
22, name=3D61-dev-root-link.rules
[  756.732899] get_one_event: event_size=3D48 > count=3D38, name_len=3D=
22, name=3D61-dev-root-link.rules
[  756.763126] get_one_event: event_size=3D48 > count=3D38, name_len=3D=
22, name=3D61-dev-root-link.rules
[  756.794829] get_one_event: event_size=3D48 > count=3D38, name_len=3D=
22, name=3D61-dev-root-link.rules
[  756.824985] get_one_event: event_size=3D48 > count=3D38, name_len=3D=
22, name=3D61-dev-root-link.rules
[  756.856760] get_one_event: event_size=3D48 > count=3D38, name_len=3D=
22, name=3D61-dev-root-link.rules
[  761.608521] __ratelimit: 210 callbacks suppressed

Which are printed by the following patch:

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-reimplement-inotify-=
using-fsnotify-report-rounded-up-event-size-to-user-space fs/notify/ino=
tify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-reimplement-inotify-usin=
g-fsnotify-report-rounded-up-event-size-to-user-space
+++ a/fs/notify/inotify/inotify_user.c
@@ -318,7 +318,9 @@ static long inotify_ioctl(struct file *f
 		mutex_lock(&group->notification_mutex);
 		list_for_each_entry(holder, &group->notification_list, event_list) {
 			event =3D holder->event;
-			send_len +=3D sizeof(struct inotify_event) + event->name_len;
+			send_len +=3D sizeof(struct inotify_event);
+			send_len +=3D roundup(event->name_len,
+					sizeof(struct inotify_event));
 		}
 		mutex_unlock(&group->notification_mutex);
 		ret =3D put_user(send_len, (int __user *) p);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead=
=2Epatch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahe=
ad.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-update.patch
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch
pagemap-add-page-types-tool.patch
pagemap-export-pg_hwpoison.patch
pagemap-export-pg_hwpoison-fix.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
pm-hibernate-rework-shrinking-of-memory.patch
pm-hibernate-do-not-release-preallocated-memory-unnecessarily-rev-2.pat=
ch
pm-hibernate-do-not-try-to-allocate-too-much-memory-too-hard.patch
inotify-reimplement-inotify-using-fsnotify-report-rounded-up-event-size=
-to-user-space.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
