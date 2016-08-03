From: akpm@linux-foundation.org
Subject: [patch 12/18] drivers/media/dvb-frontends/cxd2841er.c: avoid
 misleading gcc warning
Date: Wed, 03 Aug 2016 13:46:21 -0700
Message-ID: <57a2581d.W7e8FTdZl4htgxz7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345AbcHCUqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:46:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de, aospan@netup.ru, jbaron@akamai.com, mchehab@kernel.org, serjk@netup.ru

From: Arnd Bergmann <arnd@arndb.de>
Subject: drivers/media/dvb-frontends/cxd2841er.c: avoid misleading gcc warning

The addition of jump label support in dynamic_debug caused an unexpected
warning in exactly one file in the kernel:

drivers/media/dvb-frontends/cxd2841er.c: In function 'cxd2841er_tune_tc':
include/linux/dynamic_debug.h:134:3: error: 'carrier_offset' may be used uninitialized in this function [-Werror=maybe-uninitialized]
   __dynamic_dev_dbg(&descriptor, dev, fmt, \
   ^~~~~~~~~~~~~~~~~
drivers/media/dvb-frontends/cxd2841er.c:3177:11: note: 'carrier_offset' was declared here
  int ret, carrier_offset;
           ^~~~~~~~~~~~~~

The problem seems to be that the compiler gets confused by the extra
conditionals in static_branch_unlikely, to the point where it can no
longer keep track of which branches have already been taken, and it
doesn't realize that this variable is now always initialized when it gets
used.

I have done lots of randconfig kernel builds and could not find any other
file with this behavior, so I assume it's a rare enough glitch that we
don't need to change the jump label support but instead just work around
the warning in the driver.

To achieve that, I'm moving the check for the return value into the
switch() statement, which is an obvious transformation, but is enough to
un-confuse the compiler here.  The resulting code is not as nice to read,
but at least we retain the behavior of warning if it gets changed to
actually access an uninitialized carrier offset value in the future.

Link: http://lkml.kernel.org/r/20160713204342.1221511-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Abylay Ospan <aospan@netup.ru>
Cc: Sergey Kozlov <serjk@netup.ru>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb-frontends/cxd2841er.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/media/dvb-frontends/cxd2841er.c~cxd2841er-avoid-misleading-gcc-warning drivers/media/dvb-frontends/cxd2841er.c
--- a/drivers/media/dvb-frontends/cxd2841er.c~cxd2841er-avoid-misleading-gcc-warning
+++ a/drivers/media/dvb-frontends/cxd2841er.c
@@ -3378,20 +3378,28 @@ static int cxd2841er_tune_tc(struct dvb_
 				ret = cxd2841er_get_carrier_offset_i(
 						priv, p->bandwidth_hz,
 						&carrier_offset);
+				if (ret)
+					return ret;
 				break;
 			case SYS_DVBT:
 				ret = cxd2841er_get_carrier_offset_t(
 					priv, p->bandwidth_hz,
 					&carrier_offset);
+				if (ret)
+					return ret;
 				break;
 			case SYS_DVBT2:
 				ret = cxd2841er_get_carrier_offset_t2(
 					priv, p->bandwidth_hz,
 					&carrier_offset);
+				if (ret)
+					return ret;
 				break;
 			case SYS_DVBC_ANNEX_A:
 				ret = cxd2841er_get_carrier_offset_c(
 					priv, &carrier_offset);
+				if (ret)
+					return ret;
 				break;
 			default:
 				dev_dbg(&priv->i2c->dev,
@@ -3399,8 +3407,6 @@ static int cxd2841er_tune_tc(struct dvb_
 					__func__, priv->system);
 				return -EINVAL;
 			}
-			if (ret)
-				return ret;
 			dev_dbg(&priv->i2c->dev, "%s(): carrier offset %d\n",
 				__func__, carrier_offset);
 			p->frequency += carrier_offset;
_
