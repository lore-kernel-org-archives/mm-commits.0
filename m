From: akpm@linux-foundation.org
Subject: + vfs-lseekfd-0-seek_cur-race-condition.patch added to -mm tree
Date: Mon, 10 Nov 2008 17:08:18 -0800
Message-ID: <200811110108.mAB18Ih9031100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbYKKBIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 20:08:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alain@knaff.lu, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     VFS: lseek(fd, 0, SEEK_CUR) race condition
has been added to the -mm tree.  Its filename is
     vfs-lseekfd-0-seek_cur-race-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: VFS: lseek(fd, 0, SEEK_CUR) race condition
From: Alain Knaff <alain@knaff.lu>

This patch fixes a race condition in lseek.  While it is expected that
unpredictable behaviour may result while repositioning the offset of a
file descriptor concurrently with reading/writing to the same file
descriptor, this should not happen when merely *reading* the file
descriptor's offset.

Unfortunately, the only portable way in Unix to read a file
descriptor's offset is lseek(fd, 0, SEEK_CUR); however executing this
concurrently with read/write may mess up the position, as shown by the
testcase below:

#include <sys/types.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <pthread.h>

void *loop(void *ptr)
{
  fprintf(stderr, "Starting seek thread\n");
  while(1) {
    if(lseek(0, 0LL, SEEK_CUR) < 0LL)
      perror("seek");
  }
}

int main(int argc, char **argv) {
  long long l=0;
  int r;
  char buf[4096];

  pthread_t thread;
  pthread_create(&thread, 0, loop, 0);

  for(r=0; 1 ; r++) {
    int n = read(0, buf, 4096);
    if(n == 0)
      break;
    if(n < 4096) {
      fprintf(stderr, "Short read %d %s\n", n, strerror(errno));
    }
    l+= n;
  }
  fprintf(stderr, "Read %lld bytes\n", l);

  return 0;
}

Compile this and run it on a multi-processor machine as
 ./a.out <bigFile

where bigFile is a 1 Gigabyte file. It should print 1073741824.
However, on a buggy kernel, it usually produces a bigger number. The
problem only happens on a multiprocessor machine. This is because an
lseek(fd, 0, SEEK_CUR) running concurrently with a read() or write()
will reset the position back to what it used to be when the read()
started.

This behavior was observed "in the wild" when using udpcast which uses
lseek to monitor progress of reading/writing the uncompressed data.

The patch below fixes the issue by "special-casing" the lseek(fd, 0,
SEEK_CUR) pattern.

Apparently, an attempt was already made to fix the issue by the
following code:

		if (offset != file->f_pos) {
			file->f_pos = offset;
			file->f_version = 0;
		}

However, this doesn't work if file->f_pos was changed (by read() or
write()) between the time offset was computed, and the time where it
considers writing it back.

Signed-off-by: Alain Knaff <alain@knaff.lu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/read_write.c~vfs-lseekfd-0-seek_cur-race-condition fs/read_write.c
--- a/fs/read_write.c~vfs-lseekfd-0-seek_cur-race-condition
+++ a/fs/read_write.c
@@ -105,6 +105,8 @@ loff_t default_llseek(struct file *file,
 			offset += i_size_read(file->f_path.dentry->d_inode);
 			break;
 		case SEEK_CUR:
+			if(offset == 0)
+				return file->f_pos;
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;
_

Patches currently in -mm which might be from alain@knaff.lu are

vfs-lseekfd-0-seek_cur-race-condition.patch
vfs-lseekfd-0-seek_cur-race-condition-fix.patch

